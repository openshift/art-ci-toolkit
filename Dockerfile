FROM registry.access.redhat.com/ubi8/ubi:latest

# Trust the Red Hat IT Root CA and set up rcm-tools repo
RUN curl -o /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt --fail -L \
         https://password.corp.redhat.com/RH-IT-Root-CA.crt \
 && update-ca-trust extract

# Install epel repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
# Install additional repos
COPY assets/repos/ /etc/yum.repos.d/

# Install dependencies
RUN \
  yum install -y \
    @python38 \
    gcc \
    gcc-c++ \
    git \
    jq \
    krb5-devel \
    libcurl-devel \
    libgit2 \
    openssl-devel \
    wget \
    mailx \
    postfix \
    krb5-workstation \
    python38-{devel,wheel,cryptography} rhpkg && \
  yum autoremove && yum clean all && \
  update-alternatives --set python3 /usr/bin/python3.8
RUN \
  python3 -m pip --no-cache-dir install pip>=21 setuptools>=45 && \
  python3 -m pip --no-cache-dir install --ignore-installed \
    koji tox twine wheel codecov future \
    git+https://github.com/openshift/doozer.git \
    git+https://github.com/openshift/elliott.git \
    git+https://github.com/openshift/ocp-build-data-validator.git

CMD ["tox"]
