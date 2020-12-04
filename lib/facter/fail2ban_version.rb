# frozen_string_literal: true

# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil -*- vim:sta:et:sw=2:ts=2:syntax=ruby

Facter.add(:fail2ban_version) do
  setcode do
    fail2ban_version = %x(fail2ban-client --version 2>/dev/null | grep ^Fail2Ban | head -1 | sed 's/Fail2Ban v//')
    if fail2ban_version == ''
      fail2ban_version = '0.0.0'
    end
    fail2ban_version
  end
end
