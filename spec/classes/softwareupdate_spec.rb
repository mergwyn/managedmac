require 'spec_helper'

describe 'managedmac::softwareupdate', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:mobileconfig_name)   { 'managedmac.softwareupdate.alacarte' }
      let(:asus_plist)          { '/Library/Preferences/com.apple.SoftwareUpdate.plist' }

      context 'when setting $catalog_url' do
        context 'when undef' do
          let(:params) do
            { catalog_url: :undef }
          end

          it {
            is_expected.to contain_mobileconfig(mobileconfig_name)\
              .with_ensure('absent')
          }
        end
        context 'when not a URL-like' do
          let(:params) do
            { catalog_url: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a URL' do
          let(:params) do
            { catalog_url: 'http://foo.bar.com/foo.sucatalog' }
          end

          it {
            is_expected.to contain_mobileconfig(mobileconfig_name)\
              .with_ensure('present')
          }
        end
      end

      context 'when setting $allow_pre_release_installation' do
        context 'when undef' do
          let(:params) do
            { allow_pre_release_installation: :undef }
          end

          it {
            is_expected.to contain_mobileconfig(mobileconfig_name)\
              .with_ensure('absent')
          }
        end
        context 'when not Boolean' do
          let(:params) do
            { allow_pre_release_installation: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a Boolean' do
          let(:params) do
            { allow_pre_release_installation: false }
          end

          it {
            is_expected.to contain_mobileconfig(mobileconfig_name)\
              .with_ensure('present')
          }
        end
      end

      context 'when setting $automatic_update_check' do
        context 'when a undef' do
          let(:params) do
            { automatic_update_check: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { automatic_update_check: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { automatic_update_check: true }
          end

          it {
            is_expected.to contain_property_list(asus_plist)
              .with_ensure('present')
          }
        end
      end

      context 'when setting $automatic_download' do
        context 'when a undef' do
          let(:params) do
            { automatic_download: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { automatic_download: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { automatic_download: true }
          end

          it {
            is_expected.to contain_property_list(asus_plist)
              .with_ensure('present')
          }
        end
      end

      context 'when setting $config_data_install' do
        context 'when a undef' do
          let(:params) do
            { config_data_install: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { config_data_install: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { config_data_install: true }
          end

          it {
            is_expected.to contain_property_list(asus_plist)
              .with_ensure('present')
          }
        end
      end

      context 'when setting $critical_update_install' do
        context 'when a undef' do
          let(:params) do
            { critical_update_install: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { critical_update_install: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { critical_update_install: true }
          end

          it {
            is_expected.to contain_property_list(asus_plist)
              .with_ensure('present')
          }
        end
      end

      describe '$auto_update_apps' do
        let(:commerce_plist) { '/Library/Preferences/com.apple.commerce.plist' }

        context 'when undef' do
          let(:params) do
            { auto_update_apps: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { auto_update_apps: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { auto_update_apps: true }
          end

          it {
            is_expected.to contain_property_list(commerce_plist)
              .with_ensure('present')
          }
        end
      end

      describe '$auto_update_restart_required' do
        let(:commerce_plist) { '/Library/Preferences/com.apple.commerce.plist' }

        context 'when undef' do
          let(:params) do
            { auto_update_restart_required: :undef }
          end

          it { is_expected.to compile.with_all_deps }
        end
        context 'when not a boolean' do
          let(:params) do
            { auto_update_restart_required: 'foo' }
          end

          it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
        end
        context 'when a boolean' do
          let(:params) do
            { auto_update_restart_required: true }
          end

          it {
            is_expected.to contain_property_list(commerce_plist)
              .with_ensure('present')
          }
        end
      end
    end
  end
end
