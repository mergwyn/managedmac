require 'spec_helper'

describe 'managedmac', :type => 'class' do
  
  # managedmac is for Darwin and more specfically, macosx_productversion_major >= 10.9
  context "on an unsupported operating system" do
    # setup some variables
    unsupported_examples = ['Debian', 'RedHat', 'CentOS', 'Windows', 'OpenSuSE', 'SuSE']
    random_os_family = unsupported_examples[rand(unsupported_examples.length - 1)]
    # fabricate a Facter fact
    let :facts do
      { :osfamily => random_os_family }
    end
    # Finally, test the code
    it "should raise a Puppet:Error" do 
      expect { should compile }.to raise_error(Puppet::Error, /unsupported osfamily/)
    end
  end
  
  context "on an unsupported product version" do
    # here we setup two fake facts:
    # yes, we are Darwin
    # no, we are not Mavericks (10.9)
    let :facts do
      { 
        :osfamily => 'Darwin',
        :macosx_productversion_major => '10.8',
      }
    end
    # Test the Puppet fail directive
    it "should raise a Puppet:Error" do 
      expect { should compile }.to raise_error(Puppet::Error, /unsupported product version/)
    end
  end
  
  # The remainder of our specs will go inside this context block
  context "on a supported operating system and product version" do
    # On our target platform, we should have green lights.
    let :facts do
      { 
        :osfamily => 'Darwin',
        :macosx_productversion_major => '10.9',
      }
    end
    
    context "when NTP configuration options are set" do
      hash = { 'servers' => ['time.apple.com', 'time1.google.com'], 'max_offset' => 120, }
      let :hiera_data do
        {
          'managedmac::ntp::options' => hash
        }
      end
      it { should contain_class('managedmac::ntp') }
      it { should compile.with_all_deps }
    end
    
  end
  
end