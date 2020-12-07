# frozen_string_literal: true

require 'spec_helper_acceptance'

# describe 'a feature', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
describe 'Fail2ban module' do
  let(:pp) do
    <<-MANIFEST
      class { 'fail2ban':
        ensure         => present,
        service_enable => false,
        service_ensure => 'stopped',
      }
    MANIFEST
  end

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  # describe command("PYTHONPATH=/opt/nixadmutils/lib/python /opt/nixadmutils/bin/wtfalert -l #{logfn}") do
  #   its(:stderr) { is_expected.to eq '' }
  #   its(:exit_status) { is_expected.to eq 0 }
  #   its(:stdout) { is_expected.to match %r{:created} }
  # end

  # describe command("PYTHONPATH=/opt/nixadmutils/lib/python /opt/nixadmutils/bin/wtflogger -Ll #{logfn} 'this is a test'") do
  #   its(:stdout) { is_expected.to eq '' }
  #   its(:exit_status) { is_expected.to eq 0 }
  #   its(:stderr) { is_expected.to match %r{INFO: this is a test} }
  # end

  describe file('/etc/fail2ban/jail.d/00-defaults-puppet.conf') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{destemail = root@.*\nsender = fail2ban@.*\nbantime = 7200\nignoreip = 127.0.0.1/8,::1} }
  end

  describe file('/etc/fail2ban/jail.d/sshd.conf') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{\[sshd\]\nenabled = true} }
  end

  describe command('fail2ban-client --version') do
    its(:stderr) { is_expected.to eq '' }
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{Fail2Ban v\d+.\d+.\d+} }
  end
end
