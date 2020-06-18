FROM centos:8

RUN yum install -y epel-release @python27 @python36
RUN yum install -y \
  gcc \
  git \
  jq \
  krb5-devel \
  libcurl-devel \
  libgit2 \
  openssl-devel \
  rpm-devel \
  python{2,3}-{devel,pip}

# Those environment variables are required to install pycurl, koji, and rpkg with pip
ENV PYCURL_SSL_LIBRARY=openssl RPM_PY_SYS=true

RUN pip2 install koji
RUN pip3 install tox twine setuptools wheel codecov future
RUN pip2 install rh-doozer==1.0.18 rh-elliott==1.0.4 rh-ocp-build-data-validator==0.1.10

RUN useradd -ms /bin/bash -u 1000 art
USER art

CMD ["tox"]
