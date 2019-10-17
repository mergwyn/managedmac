require 'spec_helper'

describe 'managedmac::users', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when $accounts is invalid' do
        let(:params) do
          { accounts: 'This is not a Hash.' }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $defaults is invalid' do
        let(:params) do
          {
            accounts: { fake: 'data' },
            defaults: 'This is not a Hash.',
          }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $accounts is empty' do
        let(:params) do
          { accounts: {} }
        end

        specify { is_expected.not_to contain_user }
      end

      context 'when $accounts contains invalid data' do
        let(:params) do
          the_data = accounts_users.merge('bad_data' => 'Not a Hash.')
          { accounts: the_data }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $accounts is VALID' do
        let(:params) do
          { accounts: accounts_users }
        end

        it do
          is_expected.to contain_user('foo').with(
            'ensure'  => 'present',
            'uid'     => '501',
          )
        end
        it do
          is_expected.to contain_user('bar').with(
            'ensure'  => 'present',
            'uid'     => '502',
          )
        end
      end
    end
  end
end
