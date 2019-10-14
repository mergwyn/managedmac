module Puppet::Parser::Functions
  newfunction(:process_mobileconfig_params, type: :rvalue, doc: <<-EOS
Returns a Payload Array for Mobileconfig type. Accepts a Hash. Each key is a
string representing the PayloadType key. The value of said key is the payload
data. Keys with empty or :undef values will be expunged.
    EOS
             ) do |args|

    if args.size != 1
      e = "process_mobileconfig_params(): Wrong number of args: #{args.size} for 1"
      raise(Puppet::ParseError, e)
    end

    params = args[0]

    unless params.is_a? Hash
      e = "process_mobileconfig_params(): Wrong arg type! (#{params.class} instead of Hash)"
      raise(Puppet::ParseError, e)
    end

    params.each_with_object([]) do |(domain, hash), memo|
      hash.delete_if { |_k, v| (v.respond_to?(:empty?) && v.empty?) || v == :undef }
      unless hash.empty?
        hash['PayloadType'] = domain
        memo << hash
      end
    end
  end
end
