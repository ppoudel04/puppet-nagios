# Create custom nagios_ipa_replication if ipa-server is found

if FileTest.exist?('/usr/sbin/ipactl')
  Facter.add('nagios_ipa_server') { setcode { true } }
end

