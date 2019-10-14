require 'spec_helper'

describe 'managedmac', type: 'class' do
  # managedmac is for Darwin and more specfically, macosx_productversion_major >= 10.9
  context 'on an unsupported operating system' do
    # setup some variables
    unsupported_examples = ['Debian', 'RedHat', 'CentOS', 'Windows', 'OpenSuSE', 'SuSE']
    random_os_family = unsupported_examples[rand(unsupported_examples.length - 1)]
    # fabricate a Facter fact
    let :facts do
      { osfamily: random_os_family }
    end

    # Finally, test the code
    it 'raises a Puppet:Error' do
      is_expected.to raise_error(Puppet::Error, %r{unsupported osfamily})
    end
  end

  context 'on an unsupported product version' do
    # here we setup two fake facts:
    # yes, we are Darwin
    # no, we are not Mavericks (10.9)
    let :facts do
      {
        osfamily: 'Darwin',
        macosx_productversion_major: '10.8',
      }
    end

    # Test the Puppet fail directive
    it 'raises a Puppet:Error' do
      is_expected.to raise_error(Puppet::Error, %r{unsupported product version})
    end
  end

  # The remainder of our specs will go inside this context block
  context 'on a supported operating system and product version' do
    # On our target platform, we should have green lights.
    let :facts do
      {
        osfamily: 'Darwin',
        macosx_productversion_major: '10.10',
      }
    end

    it { is_expected.to contain_class('managedmac::ntp') }
    it { is_expected.to contain_class('managedmac::activedirectory') }
    it { is_expected.to contain_class('managedmac::security') }
    it { is_expected.to contain_class('managedmac::desktop') }
    it { is_expected.to contain_class('managedmac::mcx') }
    it { is_expected.to contain_class('managedmac::filevault') }
    it { is_expected.to contain_class('managedmac::loginwindow') }
    it { is_expected.to contain_class('managedmac::softwareupdate') }
    it { is_expected.to contain_class('managedmac::authorization') }
    it { is_expected.to contain_class('managedmac::energysaver') }
    it { is_expected.to contain_class('managedmac::portablehomes') }
    it { is_expected.to contain_class('managedmac::mounts') }
    it { is_expected.to contain_class('managedmac::loginhook') }
    it { is_expected.to contain_class('managedmac::logouthook') }
    it { is_expected.to contain_class('managedmac::sshd') }
    it { is_expected.to contain_class('managedmac::remotemanagement') }
    it { is_expected.to contain_class('managedmac::screensharing') }
    it { is_expected.to contain_class('managedmac::mobileconfigs') }
    it { is_expected.to contain_class('managedmac::propertylists') }
    it { is_expected.to contain_class('managedmac::execs') }
    it { is_expected.to contain_class('managedmac::files') }
    it { is_expected.to contain_class('managedmac::users') }
    it { is_expected.to contain_class('managedmac::groups') }
    it { is_expected.to contain_class('managedmac::cron') }
  end
end
