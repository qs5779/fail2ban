require 'spec_helper'

describe 'fail2ban' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) {
        {
          'filters' => {
            'apache-access-wtfo' => {
              'ensure' => 'present',
              'ibefore' => ['apache-common.conf'],
              'failregex' => [
                '^<HOST> - - \[.*\] "[A-Z]* .*(?i)fckeditor.*" 404',
                '^<HOST> - - \[.*\] "[A-Z]* .*(?i)phpmyadmin.*" 404',
              ]
            }
          }
        }
      }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/fail2ban/jail.d/00-defaults-puppet.conf') }
      it { is_expected.to contain_file('/etc/fail2ban/jail.d/sshd.conf') }
      it { is_expected.to contain_file('/etc/fail2ban/filter.d/apache-access-wtfo.local') }
    end
  end
end

