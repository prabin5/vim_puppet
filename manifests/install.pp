# Class vim_puppet::install
# This class installs required packages and sets up vim plugins
#
class vim_puppet::install(){

  # Assign variables
  $_disable_puppetlint    = $vim_puppet::disable_puppetlint
  $_show_lint_warning     = $vim_puppet::show_lint_warning
  $_disable_puppet_parser = $vim_puppet::disable_puppet_parser
  $_vimrc_url             = 'https://github.com/ricciocri/vimrc.git'
  $_exec_path             = $vim_puppet::exec_path
  $_misc_packages         = $vim_puppet::misc_packages
  
  # Validate parameters
  validate_string($_vimrc_url)

  # Setup default exec path
  Exec {
    path => $_exec_path
  }

  if (versioncmp("${::puppetversion}" , '3.6.0' ) >=0)  {
    Package { allow_virtual => $vim_puppet::virtual_package }
  } 

    
  # Install misc packages
  package  {$_misc_packages:
    ensure => $vim_puppet::package_ensure,
  }

  # Install puppet-lint
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem'
  }

  # Backup existing .vim dir and .vimrc file before setting up puppet vim 
  exec { 'Backup existing .vim dir':
    command => 'mkdir -p /root/.vim; touch /root/.vimrc; \
                mv /root/.vim /root/.vim_backup; \
                mv /root/.vimrc /root/.vimrc_backup ',
    unless  => "test \"`cd /root/.vim ; git config --get \
                remote.origin.url`\" = ${_vimrc_url}",
    }
  ->
  # Install vimrc along with submodule init
  vcsrepo { '/root/.vim':
    ensure   => present,
    provider => git,
    source   => $_vimrc_url,
  }
  ->
  # Setup .vimrc file
  file {'/root/.vimrc':
    content => template('vim_puppet/vimrc.erb'),
  }
}
