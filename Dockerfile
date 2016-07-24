# Dockerfile
FROM centos:centos7.1.1503
MAINTAINER Cedric Carregues <cedric.carregues@neuvosys.com>
 
# update yum repository and install openssh server
RUN yum update -y && yum -y install openssh-server
  
# generate ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
   
# change root password
RUN echo 'root:password' | chpasswd
    
# SSH login fix. Otherwise user is kicked off after login
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
     
# expose ssh port and start deamon
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
