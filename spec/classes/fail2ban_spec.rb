require 'spec_helper'

describe 'fail2ban', :type => 'class' do

  let(:params) {
    {
      'filters' =>
        'apache-acess-wtfo' => {
            ensure => 'present',
            before => [ 'apache-common.conf', 'foo-common.local' ],
            failregex => [
              '^<HOST> - - \[.*\] "[A-Z]* .*(?i)fckeditor.*" 404',
              '^<HOST> - - \[.*\] "[A-Z]* .*(?i)phpmyadmin.*" 404'
            ],
          }
        }
      }
    }

  context "On a RedHat OS with no overrides" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end
    it { is_expected.to contain_file('/etc/fail2ban/jail.d/00-defaults-puppet.conf') }
    it { is_expected.to contain_file('/etc/fail2ban/jail.d/sshd.conf') }
    it { is_expected.to contain_file('/etc/fail2ban/filter.d/apache-acess-wtfo.local') }
  end


end
