### Staging Environment Keys
This directory contains the public keys for the staging environment

In order to generate the public key from a .pem file, use
```bash
ssh-keygen -y -f keyfile.pem > product_environment.pub
```
Note that all key files should be read-only. For example, if you have generated a keyfile called mykeys.pem for a new product named abc

```bash
chmod 400 mykeys.pem
ssh-keygen -y -f mykeys.pem > abc_staging.pub
chmod 400 abc_staging.pub
```
