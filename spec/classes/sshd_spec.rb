require 'spec_helper'

describe 'managedmac::sshd', type: 'class' do
  context 'when $enable == undef' do
    let(:params) do
      { enable: '' }
    end

    it { is_expected.not_to contain_macgroup('com.apple.access_ssh-disabled') }
    it { is_expected.not_to contain_macgroup('com.apple.access_ssh') }
    it { is_expected.not_to contain_service('com.openssh.sshd') }
    it { is_expected.not_to contain_file('sshd_config') }
    it { is_expected.not_to contain_file('sshd_banner') }
  end

  context 'when $enable != undef' do
    context 'when $enable == false' do
      let(:params) do
        { enable: false }
      end

      it do
        is_expected.to contain_macgroup(
          'com.apple.access_ssh-disabled',
        ).with_ensure('absent')
      end
      it do
        is_expected.to contain_macgroup(
          'com.apple.access_ssh',
        ).with_nestedgroups(
          ['ABCDEFAB-CDEF-ABCD-EFAB-CDEF00000050'],
        )
      end
      it do
        is_expected.to contain_service('com.openssh.sshd').with_ensure(false)
      end
    end

    context 'when $enable == true' do
      let(:params) do
        { enable: true }
      end

      it do
        is_expected.to contain_macgroup(
          'com.apple.access_ssh-disabled',
        ).with_ensure('absent')
      end
      it do
        is_expected.to contain_macgroup(
          'com.apple.access_ssh',
        ).with_nestedgroups(
          ['ABCDEFAB-CDEF-ABCD-EFAB-CDEF00000050'],
        )
      end
      it do
        is_expected.to contain_service('com.openssh.sshd').with_ensure(true)
      end

      context 'when users are defined' do
        let(:params) do
          { enable: true, users: ['foo', 'bar', 'bar'] }
        end

        it do
          is_expected.to contain_macgroup(
            'com.apple.access_ssh',
          ).with_users(
            ['foo', 'bar', 'bar'],
          )
        end
        it do
          is_expected.to contain_service('com.openssh.sshd').with_ensure(true)
        end
      end

      context 'when groups are defined' do
        let(:params) do
          { enable: true, groups: ['foo', 'bar', 'bar'] }
        end

        it do
          is_expected.to contain_macgroup(
            'com.apple.access_ssh',
          ).with_nestedgroups(
            ['foo', 'bar', 'bar'],
          )
        end
        it do
          is_expected.to contain_service('com.openssh.sshd').with_ensure(true)
        end
      end

      context 'when sshd_config is defined' do
        let(:params) do
          {
            enable: true,
            sshd_config: 'puppet:///modules/mmv2/services/sshd/sshd_config',
          }
        end

        it do
          is_expected.to contain_file('sshd_config').with_ensure('file')
        end
        it do
          is_expected.to contain_service('com.openssh.sshd').with_ensure(true)
        end
      end

      context 'when sshd_banner is defined' do
        let(:params) do
          {
            enable: true,
            sshd_banner: 'puppet:///modules/mmv2/services/sshd/sshd_banner',
          }
        end

        it do
          is_expected.to contain_file('sshd_banner').with_ensure('file')
        end
        it do
          is_expected.to contain_service('com.openssh.sshd').with_ensure(true)
        end
      end

      context 'when sshd_banner is a BAD path' do
        let(:params) do
          {
            enable: true,
            sshd_banner: 'this is not valid',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{does not match}) }
      end
    end
  end
end
