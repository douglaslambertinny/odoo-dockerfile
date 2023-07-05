# Docker build odoo:16 to be used with docker-compose.yml

# Official Odoo image.
FROM --platform=linux/amd64 odoo:16

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Use root for setup.
USER root

# Install Odoo
ENV ODOO_VERSION 16.0
ARG ODOO_RELEASE=20230629
ARG ODOO_SHA=ef1a7436be87a897efa0d0b4a50a159d2ee3e1e3
RUN curl -o odoo.deb -sSL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
    && apt-get update \
    && apt-get -y install --no-install-recommends ./odoo.deb \
    && rm -rf /var/lib/apt/lists/* odoo.deb

# Upgrade pip.
RUN set -x; \
    pip3 install --no-cache-dir --upgrade pip

# Install system dependencies.
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; apt-get update && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    dirmngr \
    fonts-noto-cjk \
    libssl-dev \
    node-less \
    npm \
    python3-magic \
    python3-num2words \
    python3-odf \
    python3-pdfminer \
    python3-pip \
    python3-phonenumbers \
    python3-pyldap \
    python3-qrcode \
    python3-renderpm \
    python3-setuptools \
    python3-slugify \
    python3-vobject \
    python3-watchdog \
    python3-xlrd \
    python3-xlwt \
    xz-utils\
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb


# Install application dependencies.
COPY requirements.txt /
RUN set -x; \
    pip3 install --no-cache-dir -r requirements.txt

# Back to default user.
USER odoo
