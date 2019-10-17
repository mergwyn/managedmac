require 'spec_helper'

describe 'managedmac::loginwindow', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when NO params are passed' do
        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_ensure('absent')
        }
        it {
          is_expected.to contain_macgroup('com.apple.access_loginwindow')\
            .with_ensure('absent')
        }
      end

      context 'when passed a BAD param' do
        context 'when $allow_list is NOT an array' do
          let(:params) do
            { allow_list: 'foobar' }
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end

        context 'when $deny_list is NOT an array' do
          let(:params) do
            { deny_list: 'foobar' }
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end

        context 'when $disable_console_access is NOT bool' do
          let(:params) do
            { disable_console_access: 'foobar' }
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end

        context 'when $loginwindow_text is NOT a String' do
          let(:params) do
            { loginwindow_text: [] }
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end

        context 'when $retries_until_hint is NOT an Integer' do
          let(:params) do
            { retries_until_hint: 'foobar' }
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end
      end

      context 'when passed one or more GOOD parameters' do
        let(:params) do
          {
            loginwindow_text: 'An important message.',
            disable_console_access: true,
            show_name_and_password_fields: true,
          }
        end

        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_ensure('present')
        }
        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_content(%r{An important message})
        }
        it {
          is_expected.to contain_macgroup('com.apple.access_loginwindow')\
            .with_ensure('absent')
        }
      end

      context 'when the loginwindow ACL is NOT set' do
        it {
          is_expected.to contain_macgroup('com.apple.access_loginwindow')\
            .with_ensure('absent')
        }
      end

      context 'when setting the loginwindow ACL' do
        let(:params) do
          {
            users: ['fry', 'bender'],
            groups: ['robothouse'],
          }
        end

        it {
          is_expected.to contain_macgroup('com.apple.access_loginwindow').with(
            'ensure' => 'present',
            'users'  => ['fry', 'bender'],
            'nestedgroups' => ['robothouse'],
          )
        }
      end

      context 'when disabling the Guest Account' do
        let(:params) do
          {
            disable_guest_account: true,
          }
        end

        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_content(%r{DisableGuestAccount.*EnableGuestAccount})
        }
      end

      context 'when enforcing an auto_logout_delay' do
        let(:params) do
          {
            auto_logout_delay: 3600,
          }
        end

        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_content(%r{com.apple.autologout.AutoLogOutDelay})
        }
      end

      context 'when enabling or disabling Fast User Switching' do
        let(:params) do
          {
            enable_fast_user_switching: true,
          }
        end

        it {
          is_expected.to contain_mobileconfig('managedmac.loginwindow.alacarte')\
            .with_content(%r{MultipleSessionEnabled})
        }
      end
    end
  end
end
