# Certificate Expiration

Playbook shows the numnber of days until the certificate will expire.


## Usage

Option 1: Set cert_site variable using extra vars option

```
ansible-playbook --extra-vars "cert_site=www.bing.com" cert_expires.yaml
```

Option 2: Update the value for the cert_site variable on line 7 and run `ansible-playbook cert_expires.yaml`

```
     1	---
     2	
     3	- name: Certificate Expiration
     4	  hosts: localhost
     5	  connection: local
     6	  vars:
     7	    - cert_site: www.google.com
     8	
     9	  tasks:
```



### Credits

Based on example from https://docs.ansible.com/ansible/latest/collections/community/crypto/get_certificate_module.html#examples




