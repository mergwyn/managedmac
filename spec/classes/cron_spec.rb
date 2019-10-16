require 'spec_helper'

describe 'managedmac::cron', type: 'class' do
  on_supported_os.each do |os, facts|
    let(:node) { 'testhost.test.com' }

    context "on #{os}" do
      let(:facts) { facts }

      context 'when $jobs is invalid' do
        let(:params) do
          { jobs: 'This is not a Hash.' }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $defaults is invalid' do
        let(:params) do
          {
            jobs: { fake: 'data' },
            defaults: 'This is not a Hash.',
          }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $jobs is empty' do
        let(:params) do
          { jobs: {} }
        end

        specify { is_expected.not_to contain_cron('') }
      end

      context 'when $jobs contains invalid data' do
        let(:params) do
          the_data = cron_jobs.merge('bad_data' => 'Not a Hash.')
          { jobs: the_data }
        end

        it { is_expected.to raise_error(Puppet::Error) }
      end

      context 'when $jobs is VALID' do
        let(:params) do
          { jobs: cron_jobs }
        end

        it do
          is_expected.to contain_cron('who_dump').with(
            'command' => '/usr/bin/who > /tmp/who.dump',
          )
        end
        it do
          is_expected.to contain_cron('ps_dump').with(
            'command' => '/bin/ps aux > /tmp/ps.dump',
          )
        end
      end
    end
  end
end
