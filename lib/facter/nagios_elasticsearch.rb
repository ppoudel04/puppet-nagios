# Create custom nagios_elasticsearch if elasticsearch binary is found

if FileTest.exist?('/usr/share/elasticsearch/bin/elasticsearch')
  Facter.add('nagios_elasticsearch') { setcode { true } }
end

