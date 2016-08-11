FROM mysql 
MAINTAINER John Walsh <michaeljohn32@yahoo.com>


# Install ansible
RUN apt-get update
RUN apt-get install -y ansible openssh-client 

# Clear apt lists
RUN rm -rf /var/lib/apt/lists/*

# Set up localhost inventory
RUN echo "localhost ansible_connection=local" >> /etc/ansible/hosts

# Copy latest ansible code
ADD support_files/ansible /etc/ansible

RUN cd /etc/ansible && ansible-playbook install-mysql.yml
