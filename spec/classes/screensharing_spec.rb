require 'spec_helper'

describe 'managedmac::screensharing', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when $enable == undef' do
        let(:params) do
          { enable: :undef }
        end

        it { is_expected.not_to contain_macgroup('com.apple.access_screensharing') }
        it { is_expected.not_to contain_service('com.apple.screensharing') }
      end

      context 'when $enable != undef' do
        context 'when $enable == false' do
          let(:params) do
            { enable: false }
          end

          it do
            is_expected.to contain_macgroup(
              'com.apple.access_screensharing',
            ).with_nestedgroups(
              ['ABCDEFAB-CDEF-ABCD-EFAB-CDEF00000050'],
            )
          end
          it do
            is_expected.to contain_service('com.apple.screensharing').with_ensure(false)
          end
        end

        context 'when $enable == true' do
          let(:params) do
            { enable: true }
          end

          it do
            is_expected.to contain_macgroup(
              'com.apple.access_screensharing',
            ).with_nestedgroups(
              ['ABCDEFAB-CDEF-ABCD-EFAB-CDEF00000050'],
            )
          end
          it do
            is_expected.to contain_service('com.apple.screensharing').with_ensure(true)
          end

          context 'when users are defined' do
            let(:params) do
              { enable: true, users: ['foo', 'bar', 'bar'] }
            end

            it do
              is_expected.to contain_macgroup(
                'com.apple.access_screensharing',
              ).with_users(
                ['foo', 'bar', 'bar'],
              )
            end
            it do
              is_expected.to contain_service('com.apple.screensharing').with_ensure(true)
            end
          end

          context 'when groups are defined' do
            let(:params) do
              { enable: true, groups: ['foo', 'bar', 'bar'] }
            end

            it do
              is_expected.to contain_macgroup(
                'com.apple.access_screensharing',
              ).with_nestedgroups(
                ['foo', 'bar', 'bar'],
              )
            end
            it do
              is_expected.to contain_service('com.apple.screensharing').with_ensure(true)
            end
          end
        end
      end
    end
  end
end
