require 'spec_helper'

describe 'fail2ban' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/fail2ban/jail.d/00-defaults-puppet.conf') }
      it { is_expected.to contain_file('/etc/fail2ban/jail.d/sshd.conf') }
      it { is_expected.to contain_file('/etc/fail2ban/filter.d/apache-acess-wtfo.local') }
    end
  end
end

