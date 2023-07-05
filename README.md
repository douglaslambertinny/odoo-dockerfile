## Dockerfile Odoo 16

This Dockerfile was created to be used in compose.yml

compose.yml example:
```sh
traefik:
  ...
db:
  ...
odoo:
    build: ./Dockerfile
    depends_on:
      - db
    ports:
      - 8069
      - 8072
    volumes:
      - ./config/odoo:/etc/odoo
      - ./addons:/mnt/extra-addons
      - odoo:/var/lib/odoo
    environment:
      - LANG=pt_BR.UTF-8
      - ODOO_RC=/etc/odoo/odoo.conf
```
