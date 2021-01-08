FROM registry.redhat.io/ubi8/ubi

# rhpkg included in rcm-tools-rhel-8-baseos.repo 
ADD http://download.devel.redhat.com/rel-eng/RCMTOOLS/rcm-tools-rhel-8-baseos.repo /etc/yum.repos.d/

# Some dependencies need CentOS repo
ADD ./pulp.repo /etc/yum.repos.d/

# To use extra repo need switch off ssl check
# Those environment variables are required to install pycurl, koji, and rpkg with pip
# ENV PYCURL_SSL_LIBRARY=openssl RPM_PY_SYS=true
# add yum autoremove and yum clean all at the end of install package step
# add --no-cache-dir for pip3 command to reduce cache
RUN echo "sslverify=false" >> /etc/yum.conf && \
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
  yum install -y \
  @python36 \
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
  krb5-workstation \
  python3-{devel,pygit2} rhpkg && \
  yum autoremove && yum clean all && \
  PYCURL_SSL_LIBRARY=openssl RPM_PY_SYS=true pip3 --no-cache-dir install \
  koji tox twine wheel codecov future \
  rh-doozer rh-elliott rh-ocp-build-data-validator

CMD ["tox"]
