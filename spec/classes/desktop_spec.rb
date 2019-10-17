require 'spec_helper'

describe 'managedmac::desktop', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when none of the params are set' do
        it do
          is_expected.to contain_mobileconfig('managedmac.desktop.alacarte').with_ensure('absent')
        end
      end

      context 'when $override_picture_path is invalid' do
        let(:params) do
          { override_picture_path: 'not a valid path' }
        end

        it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
      end

      context 'when $locked is not a Boolean' do
        let(:params) do
          { locked: 'not a bool' }
        end

        it { is_expected.to raise_error(Puppet::PreformattedError, %r{Evaluation Error: Error while evaluating a Resource Statement}) }
      end

      context 'when $override_picture_path param is valid' do
        let(:params) do
          { override_picture_path: '/path/to/some/file' }
        end

        specify do
          is_expected.to contain_mobileconfig('managedmac.desktop.alacarte').with_ensure('present')
        end
      end

      context 'when $locked param is valid' do
        let(:params) do
          { locked: true }
        end

        specify do
          is_expected.to contain_mobileconfig('managedmac.desktop.alacarte').with_ensure('present')
        end
      end
    end
  end
end
