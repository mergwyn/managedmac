require 'spec_helper'

describe 'managedmac::portablehomes', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context "product version doesn't matter when $enable is a BOOL" do
        context 'when $enable == true' do
          let(:params) do
            { enable: true }
          end

          it do
            is_expected.to contain_mobileconfig('managedmac.portablehomes.alacarte').with_ensure('present')
          end
        end

        context 'when $enable == false' do
          let(:params) do
            { enable: false }
          end

          it do
            is_expected.to contain_mobileconfig('managedmac.portablehomes.alacarte').with_ensure('absent')
          end
        end
      end

      context 'when $enable == $macosx_productversion_major' do
        let(:params) do
          { enable: facts[:macosx_productversion_major] }
        end

        it do
          is_expected.to contain_mobileconfig('managedmac.portablehomes.alacarte').with_ensure('present')
        end
      end

      context 'when $enable is passed a BAD param' do
        let(:params) do
          { enable: 'Whimmy wham wham wozzle!' }
        end

        it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
      end

      context 'when passed no params' do
        it do
          is_expected.to contain_mobileconfig('managedmac.portablehomes.alacarte').with_ensure('absent')
        end
      end

      context 'when $menuextra has BAD param' do
        let(:params) do
          { enable: true, menuextra: 'on' }
        end

        it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
      end

      context 'when $syncPeriodSeconds has BAD param' do
        let(:params) do
          { enable: true, syncPeriodSeconds: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{not an Integer}) }
      end

      context 'when $syncPreferencesAtLogin has BAD param' do
        let(:params) do
          { enable: true, syncPreferencesAtLogin: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{Parameter Error: invalid value}) }
      end

      context 'when $loginPrefSyncConflictResolution has BAD param' do
        let(:params) do
          { enable: true, loginPrefSyncConflictResolution: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{Parameter Error: invalid value}) }
      end

      context 'when $excludedItems has BAD param' do
        let(:params) do
          { enable: true, excludedItems: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{Wrong arg type.*String instead of Hash}) }
      end

      context 'when $syncedFolders has BAD param' do
        let(:params) do
          { enable: true, syncedFolders: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{Wrong arg type.*String instead of Array}) }
      end

      context 'when passed good params' do
        let(:params) do
          { enable: true }
        end

        it do
          is_expected.to contain_mobileconfig('managedmac.portablehomes.alacarte').with_ensure('present')
        end
      end
    end
  end
end
