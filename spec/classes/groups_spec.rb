require 'spec_helper'

describe 'managedmac::groups', type: 'class' do
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
    
        it { is_expected.to raise_error(Puppet::Error) }
      end
    
      context 'when $accounts contains invalid data' do
        let(:params) do
          the_data = accounts_groups.merge('bad_data' => 'Not a Hash.')
          { accounts: the_data }
        end
    
        it { is_expected.to raise_error(Puppet::Error) }
      end
    
      context 'when $accounts is VALID' do
        let(:params) do
          { accounts: accounts_groups }
        end
    
        it do
          is_expected.to contain_macgroup('foo_group').with(
            'gid'          => '554',
            'users'        => ['root', 'nobody', 'daemon'],
            'nestedgroups' => ['admin', 'staff'],
          )
        end
        it do
          is_expected.to contain_macgroup('bar_group').with(
            'gid'          => '555',
            'users'        => ['root', 'nobody', 'daemon'],
            'nestedgroups' => ['admin', 'staff'],
          )
        end
      end
    end
  end
end
