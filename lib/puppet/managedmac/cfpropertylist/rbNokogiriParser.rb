# -*- coding: utf-8 -*-

require 'nokogiri'

module CFPropertyList # rubocop:disable Style/ClassAndModuleChildren
  # XML parser
  class NokogiriXMLParser < ParserInterface
    # read a XML file
    # opts::
    # * :file - The filename of the file to load
    # * :data - The data to parse
    def load(opts)
      doc = nil
      if opts.key?(:file)
        File.open(opts[:file], 'rb') { |fd| doc = Nokogiri::XML::Document.parse(fd, nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT) }
      else
        doc = Nokogiri::XML::Document.parse(opts[:data], nil, nil, Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT)
      end

      if doc
        root = doc.root.children.first
        return import_xml(root)
      end
    rescue Nokogiri::XML::SyntaxError => e
      raise CFFormatError, 'invalid XML: ' + e.message
    end

    # serialize CFPropertyList object to XML
    # opts = {}:: Specify options: :formatted - Use indention and line breaks
    def to_str(opts = {})
      doc = Nokogiri::XML::Document.new
      @doc = doc

      doc.root = doc.create_element 'plist', version: '1.0'
      doc.encoding = 'UTF-8'

      doc.root << opts[:root].to_xml(self)

      # ugly hack, but there's no other possibility I know
      s_opts = Nokogiri::XML::Node::SaveOptions::AS_XML
      s_opts |= Nokogiri::XML::Node::SaveOptions::FORMAT if opts[:formatted]

      str = doc.serialize(save_with: s_opts)
      str1 = ''
      first = false
      str.each_line do |line|
        str1 << line
        unless first
          str1 << "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n" if line =~ %r{^\s*<\?xml}
        end

        first = true
      end

      str1.force_encoding('UTF-8') if str1.respond_to?(:force_encoding)
      str1
    end

    def new_node(name)
      @doc.create_element name
    end

    def new_text(val)
      @doc.create_text_node val
    end

    def append_node(parent, child)
      parent << child
    end

    protected

    # get the value of a DOM node
    def get_value(n)
      content = if n.children.empty?
                  n.content
                else
                  n.children.first.content
                end

      content.force_encoding('UTF-8') if content.respond_to?(:force_encoding)
      content
    end

    # import the XML values
    def import_xml(node)
      ret = nil

      case node.name
      when 'dict'
        hsh = {}
        key = nil
        children = node.children

        unless children.empty?
          children.each do |n|
            next if n.text? # avoid a bug of libxml
            next if n.comment?

            # rubocop:disable Metrics/BlockNesting
            if n.name == 'key'
              key = get_value(n)
            else
              raise CFFormatError, 'Format error!' if key.nil?
              hsh[key] = import_xml(n)
              key = nil
            end
            # end rubocop:disable
          end
        end

        ret = CFDictionary.new(hsh)

      when 'array'
        ary = []
        children = node.children

        unless children.empty?
          children.each do |n|
            next if n.text? # avoid a bug of libxml
            next if n.comment?
            ary.push import_xml(n)
          end
        end

        ret = CFArray.new(ary)

      when 'true'
        ret = CFBoolean.new(true)
      when 'false'
        ret = CFBoolean.new(false)
      when 'real'
        ret = CFReal.new(get_value(node).to_f)
      when 'integer'
        ret = CFInteger.new(get_value(node).to_i)
      when 'string'
        ret = CFString.new(get_value(node))
      when 'data'
        ret = CFData.new(get_value(node))
      when 'date'
        ret = CFDate.new(CFDate.parse_date(get_value(node)))
      end

      ret
    end
  end
end

# eof
