FROM centos:8

RUN yum install -y epel-release @python27 @python36
RUN yum install -y gcc git jq krb5-devel openssl-devel libcurl-devel rpm-devel \
    python{2,3}-{devel,pip}

# Those environment variables are required to install pycurl, koji, and rpkg with pip
ENV PYCURL_SSL_LIBRARY=openssl RPM_PY_SYS=true

RUN pip2 install koji
RUN pip3 install tox twine setuptools wheel codecov
RUN pip2 install rh-doozer==0.5.17 rh-elliott==0.2.12 rh-ocp-build-data-validator==0.0.8

RUN useradd -ms /bin/bash -u 1000 art
USER art

CMD ["tox"]