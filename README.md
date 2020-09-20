# puppet-casestudy

id <user>
cat /etc/passwd
groups <user>

useradd -u <uid> -d <home/dir> -g <groupid> -s <shell> name
passwd <user> 

## Display directory tree and file contents
find dummy/ -type f | xargs head -v

grep -F '' -r dummy/

puppet agent --test --debug --noop --show-diff

## Puppet modules

puppet module install pltraining-dirtree --version 0.3.0

puppet module install puppetlabs-stdlib --version 6.4.0