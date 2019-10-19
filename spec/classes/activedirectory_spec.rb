require 'spec_helper'

describe 'managedmac::activedirectory', type: 'class' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when $enable == undef' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'when $enable == false' do
        context 'when $provider is INVALID' do
          let(:params) do
            { enable: false, provider: 'whatever' }
          end

          it {
            is_expected.to raise_error(Puppet::Error, %r{Parameter :provider must be 'mobileconfig' or 'dsconfigad'})
          }
        end

        context 'when $provider == :mobileconfig' do
          context 'when $evaluate is false' do
            let(:params) do
              { enable: false, provider: 'mobileconfig', evaluate: 'false' }
            end

            specify do
              is_expected.not_to contain_mobileconfig('managedmac.activedirectory.alacarte')
            end
          end

          context "when $evaluate == 'no'" do
            let(:params) do
              { enable: false, provider: 'mobileconfig', evaluate: 'no' }
            end

            specify do
              is_expected.not_to contain_mobileconfig('managedmac.activedirectory.alacarte')
            end
          end

          context 'when $evaluate == true' do
            let(:params) do
              { enable: false, provider: 'mobileconfig', evaluate: 'true' }
            end

            specify do
              is_expected.to contain_mobileconfig('managedmac.activedirectory.alacarte').with_ensure('absent')
            end
          end
        end

        context 'when $evaluate is false' do
          let(:params) do
            { enable: false, provider: 'dsconfigad', evaluate: 'false' }
          end

          context 'when $provider == :dsconfigad' do
            specify do
              is_expected.not_to contain_dsconfigad('foo.ad.com')
            end
          end

          context "when $evaluate == 'no'" do
            let(:params) do
              { enable: false, provider: 'dsconfigad', evaluate: 'no' }
            end

            specify do
              is_expected.not_to contain_dsconfigad('foo.ad.com')
            end
          end

          context 'when $evaluate == true' do
            let(:params) do
              { enable: false, provider: 'dsconfigad', hostname: 'foo.ad.com', evaluate: 'true' }
            end

            specify do
              is_expected.to contain_dsconfigad('foo.ad.com').with_ensure('absent')
            end
          end
        end
      end

      context 'when $enable == true' do
        let(:required_params) do
          {
            hostname: 'foo.ad.com',
            username: 'account',
            password: 'password',
          }
        end

        context 'when $provider is INVALID' do
          let(:params) do
            { enable: true, provider: 'whatever' }
          end

          it {
            is_expected.to raise_error(Puppet::Error, %r{Parameter :provider must be 'mobileconfig' or 'dsconfigad'})
          }
        end

        context 'when REQUIRED params are NOT set' do
          let(:params) do
            { enable: true }
          end

          it {
            is_expected.to raise_error(Puppet::Error, %r{You must specify a.*param})
          }
        end

        context 'when $evaluate is INVALID' do
          let(:params) do
            { enable: true, evaluate: 'whatever' }
          end

          it {
            is_expected.to raise_error(Puppet::Error, %r{Parameter.*must be})
          }
        end

        context 'when $provider == :mobileconfig' do
          let(:required_params) do
            {
              enable: true,
              provider: 'mobileconfig',
              hostname: 'foo.ad.com',
              username: 'account',
              password: 'password',
            }
          end

          context 'when REQUIRED params are set' do
            let(:params) do
              required_params
            end

            specify do
              is_expected.to contain_mobileconfig('managedmac.activedirectory.alacarte').with_ensure('present')
            end
          end

          context 'when $evaluate == undef' do
            let(:params) do
              required_params.merge(evaluate: :undef)
            end

            specify do
              is_expected.to contain_mobileconfig('managedmac.activedirectory.alacarte').with_ensure('present')
            end
          end

          context "when $evaluate == 'true'" do
            let(:params) do
              required_params.merge(evaluate: 'true')
            end

            specify do
              is_expected.to contain_mobileconfig('managedmac.activedirectory.alacarte').with_ensure('present')
            end
          end

          context "when $evaluate == 'yes'" do
            let(:params) do
              required_params.merge(evaluate: 'yes')
            end

            specify do
              is_expected.to contain_mobileconfig('managedmac.activedirectory.alacarte').with_ensure('present')
            end
          end

          context "when $evaluate == 'no'" do
            let(:params) do
              required_params.merge(evaluate: 'no')
            end

            specify do
              is_expected.not_to contain_mobileconfig('managedmac.activedirectory.alacarte')
            end
          end

          context "when $evaluate == 'false'" do
            let(:params) do
              required_params.merge(evaluate: 'false')
            end

            specify do
              is_expected.not_to contain_mobileconfig('managedmac.activedirectory.alacarte')
            end
          end
        end

        context 'when $provider == :dsconfigad' do
          let(:required_params) do
            {
              enable: true,
              hostname: 'foo.ad.com',
              username: 'account',
              password: 'password',
              computer: 'computer',
            }
          end

          context 'when REQUIRED params are set' do
            let(:params) do
              required_params
            end

            specify do
              is_expected.to contain_dsconfigad('foo.ad.com').with_ensure('present')
            end
          end

          context 'when $evaluate == undef' do
            let(:params) do
              required_params.merge(evaluate: :undef)
            end

            specify do
              is_expected.to contain_dsconfigad('foo.ad.com').with_ensure('present')
            end
          end

          context "when $evaluate == 'true'" do
            let(:params) do
              required_params.merge(evaluate: 'true')
            end

            specify do
              is_expected.to contain_dsconfigad('foo.ad.com').with_ensure('present')
            end
          end

          context "when $evaluate == 'yes'" do
            let(:params) do
              required_params.merge(evaluate: 'yes')
            end

            specify do
              is_expected.to contain_dsconfigad('foo.ad.com').with_ensure('present')
            end
          end

          context "when $evaluate == 'no'" do
            let(:params) do
              required_params.merge(evaluate: 'no')
            end

            specify do
              is_expected.not_to contain_dsconfigad('foo.ad.com')
            end
          end

          context "when $evaluate == 'false'" do
            let(:params) do
              required_params.merge(evaluate: 'false')
            end

            specify do
              is_expected.not_to contain_dsconfigad('foo.ad.com')
            end
          end
        end
      end
    end
  end
end
