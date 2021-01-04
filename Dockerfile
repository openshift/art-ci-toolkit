FROM centos:8

RUN yum install -y epel-release @python36
RUN yum install -y \
  gcc \
  gcc-c++ \
  git \
  jq \
  krb5-devel \
  libcurl-devel \
  libgit2 \
  openssl-devel \
  rpm-devel \
  wget \
  mailx \
  postfix \
  krb5-libs \
  krb5-workstation \
  python3-{devel,pip,pygit2}

ADD http://download.devel.redhat.com/rel-eng/RCMTOOLS/rcm-tools-rhel-8-baseos.repo /etc/yum.repos.d/
# rhpkd didn't in default repo, and to use extra repo need switch off ssl check
RUN echo "sslverify=false" >> /etc/yum.conf; yum install -y rhpkg

# Those environment variables are required to install pycurl, koji, and rpkg with pip
ENV PYCURL_SSL_LIBRARY=openssl RPM_PY_SYS=true

RUN pip3 install koji tox twine setuptools wheel codecov future \
  rh-doozer==1.2.31 rh-elliott==1.0.18 rh-ocp-build-data-validator==0.1.24

RUN useradd -ms /bin/bash -u 1000 art
USER art

CMD ["tox"]
