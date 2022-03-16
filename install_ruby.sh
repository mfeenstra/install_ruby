#!/usr/bin/env bash
# ./install_ruby.sh
#
# Download, Compile, Build and Install RVM + Ruby 3.1.0 + Bundler
#   on CentOS 8 Stream and CentOS 8.2
#
#  matt.a.feenstra@gmail.com

source /etc/profile
RVM_RUBY_DEFAULT=ruby-3.1.0
CPUS=16

dnf install -y \
  bind-utils \
  cronie cronie-anacron curl dmidecode expect gcc \
  gcc-c++ git glibc-langpack-en glibc-locale-source \
  libffi libffi-devel libgcc libnotify libreswan \
  make mlocate ncurses net-tools \
  traceroute tree util-linux vim \
  vim-enhanced vim-filesystem wget yuicompressor

dnf update -y
dnf clean all
dnf makecache

dnf install -y \
  patch autoconf automake bison bzip2 libtool patch readline-devel \
  openssl openssl-devel

curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-only

PATH=/usr/local/rvm/gems/$RVM_RUBY_DEFAULT/bin:$PATH
echo 'rvm_silence_path_mismatch_check_flag=1' > /root/.rvmrc

/usr/local/rvm/bin/rvm get stable --auto-dotfiles
usermod -aG rvm root
source /etc/profile.d/rvm.sh

/usr/local/rvm/bin/rvm install $RVM_RUBY_DEFAULT --docs -j $CPUS --enable-jit
/usr/local/rvm/bin/rvm use $RVM_RUBY_DEFAULT --default
/usr/local/rvm/bin/rvm rvmrc warning ignore all.rvmrc

/usr/local/rvm/wrappers/$RVM_RUBY_DEFAULT/gem install bundler
/usr/local/rvm/wrappers/$RVM_RUBY_DEFAULT/gem update

echo -e "\n\nDone.\nRemember to:\n\n1)\tAdd users to 'rvm' group.\n2)\tre-login all terminals and sessions.\n"
