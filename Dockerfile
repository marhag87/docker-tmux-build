# Tmux build container
#
# VERSION 0.0.1

FROM centos:centos6
MAINTAINER Martin Hagstrom <martin@mrhg.se>

# Update
RUN yum update -y
# Install deps
RUN yum groupinstall -y "Development tools"
RUN yum install -y wget tar glibc-static

ADD build-tmux.sh /
RUN chmod a+x build-tmux.sh

# Default start options
ENTRYPOINT ["/build-tmux.sh"]
