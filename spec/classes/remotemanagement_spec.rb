require 'spec_helper'

describe 'managedmac::remotemanagement', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when none of the params is set' do
        it do
          is_expected.not_to contain_remotemanagement('apple_remote_desktop')
        end
      end

      context 'when passed a BAD param' do
        let(:params) do
          {
            enable: true,
            allow_all_users: 'a string',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{not a boolean}) }
      end

      context 'when $enable == false' do
        let(:params) do
          { enable: false }
        end

        it do
          is_expected.to contain_remotemanagement('apple_remote_desktop').with_ensure('stopped')
        end
      end

      context 'when $enable == true' do
        let(:params) do
          { enable: true }
        end

        it do
          is_expected.to contain_remotemanagement('apple_remote_desktop').with_ensure('running')
        end
      end
    end
  end
end
