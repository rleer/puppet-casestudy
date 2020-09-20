# puppet-casestudy

## Useful Unix commands

```bash
id <user>
cat /etc/passwd
groups <user>

useradd -u <uid> -d <home/dir> -g <groupid> -s <shell> name
passwd <user>
```

## Display directory tree and file contents

```bash
find dummy/ -type f | xargs head -v
grep -F '' -r dummy/
tree dummy/
```

## Puppet commands and modules

```bash
systemctl start puppetserver.service
systemctl start puppet.service

puppetserver ca list --all

puppet agent --test --debug --noop --show-diff


puppet module install pltraining-dirtree --version 0.3.0
puppet module install puppetlabs-stdlib --version 6.4.0
```

## Virtualbox from command line

```bash
vboxmanage list vms
vboxmanage list runningvms

vboxmanage startvm centos --type headless

vboxmanage startvm puppetmaster --type headless
vboxmanage startvm puppetagent01 --type headless
vboxmanage startvm puppetagent02 --type headless

vboxmanage controlvm <name> poweroff
```

```bash
puppetmaster.example.com:  192.168.100.4
ssh root@127.0.0.1 -p 2222

puppetagent01.example.com: 192.168.100.5
ssh root@127.0.0.1 -p 2223

puppetagent02.example.com: 192.168.100.6
ssh root@127.0.0.1 -p 2224
```
