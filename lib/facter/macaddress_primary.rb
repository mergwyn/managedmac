require 'puppet'

if RUBY_PLATFORM =~ %r{darwin}
  require 'cfpropertylist'
end

Facter.add('macaddress_primary') do
  confine operatingsystem: :darwin
  setcode do
    file    = '/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist'
    plist   = CFPropertyList::List.new(file: file)
    native  = CFPropertyList.native_types(plist.value)
    devices = native['Interfaces'].select { |d|
      d['IOBuiltin'] &&
        d['IOInterfaceNamePrefix'].eql?('en') && (d['IOPathMatch'] !~ %r{thunderbolt|usb|firewire}i)
    }.sort_by { |d| d['IOInterfaceUnit'] } # rubocop:disable Style/MultilineBlockChain
    devices[0]['IOMACAddress'].unpack('H*').first.scan(%r{..}).join(':')
  end
end
