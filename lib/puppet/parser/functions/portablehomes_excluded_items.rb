module Puppet::Parser::Functions
  newfunction(:portablehomes_excluded_items, type: :rvalue, doc: <<-EOS
Returns a Array of properly formatted excludeItems Hashes.
    EOS
             ) do |args|

    if args.size != 1
      e = "portablehomes_excluded_items(): Too many args! (#{args.size} instead of 1)"
      raise(Puppet::ParseError, e)
    end

    unless args[0].is_a? Hash
      e = "portablehomes_excluded_items(): Wrong arg type! (#{args[0].class} instead of Hash)"
      raise(Puppet::ParseError, e)
    end

    args[0].each_with_object([]) do |(k, v), memo|
      v.each do |p|
        memo << { 'comparison' => k, 'value' => p }
      end
    end
  end
end
