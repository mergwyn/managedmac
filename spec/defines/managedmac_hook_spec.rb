require 'spec_helper'

describe 'managedmac::hook' do
  context 'when passed no params' do
    let(:title) { 'login' }

    it { is_expected.to raise_error(Puppet::Error, %r{Must pass enable}) }
  end

  context "name != 'login' or 'logout'" do
    let(:title) { 'foo' }
    let(:params) do
      { enable: true, scripts: '/etc/loginhooks' }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{Parameter Error: invalid :name}) }
  end

  context "name == 'login' or 'logout' or derivative" do
    accepted_names = ['login', 'logout', 'LOGIN', 'LOGOUT', 'lOGiN', 'lOGOuT']
    random_name    = accepted_names[rand(accepted_names.length - 1)]

    let(:title) { random_name }

    context 'when enable is not a BOOL' do
      let(:params) do
        { enable: 'foo', scripts: '/' }
      end

      it { is_expected.to raise_error(Puppet::Error, %r{not a boolean}) }
    end

    context 'when enable == true' do
      let(:params) do
        { enable: true }
      end

      context 'when $scripts is set not set' do
        it { is_expected.to raise_error(Puppet::Error, %r{Must pass scripts}) }
      end

      context 'when $scripts is not an absolute path' do
        let(:params) do
          { enable: true, scripts: 'whatever' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{not an absolute path}) }
      end

      context 'when $scripts is an absolute path' do
        type = random_name.downcase
        let(:params) do
          { enable: true, scripts: "/etc/#{type}hooks" }
        end

        specify do
          is_expected.to contain_file("/etc/#{type}hooks").with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'wheel',
            'mode'   => '0750',
          )
        end
        specify do
          is_expected.to contain_file('/etc/masterhooks').with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'wheel',
            'mode'   => '0750',
          )
        end
        specify do
          is_expected.to contain_file("/etc/masterhooks/#{type}hook.rb").with(
            'ensure' => 'file',
            'owner'  => 'root',
            'group'  => 'wheel',
            'mode'   => '0750',
          )
        end
        it { is_expected.to contain_exec("activate_#{type}_hook") }
      end
    end

    context 'when enable == false' do
      type = random_name.downcase
      let(:params) do
        { enable: false, scripts: "/etc/#{type}hooks" }
      end

      it {
        is_expected.not_to contain_file('/etc/masterhooks').with(
          'ensure' => 'absent',
        )
      }

      it {
        is_expected.to contain_file("/etc/masterhooks/#{type}hook.rb").with(
          'ensure' => 'absent',
        )
      }

      it { is_expected.to contain_exec("deactivate_#{type}_hook") }
    end
  end
end
