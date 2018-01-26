require 'spec_helper'

describe 'fail2ban', :type => 'class' do

  context "On a RedHat OS with no overrides" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end
    it { is_expected.to contain_file('/etc/fail2ban/jail.d/00-defaults-puppet.conf') }
    it { is_expected.to contain_file('/etc/fail2ban/jail.d/sshd.conf') }
  end


end
