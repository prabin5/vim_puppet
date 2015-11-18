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
  $_user_home             = $vim_puppet::user_home
  
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

  $_git_clone_ssh = $vim_puppet::git_clone_ssh ? {
    true  => true,
    false => false,
  }

  # Backup existing .vim dir and .vimrc file before setting up puppet vim 
  exec { 'Backup existing .vim dir':
    command => "mkdir -p ${_user_home}/.vim; touch ${_user_home}/.vimrc; \
                mv ${_user_home}/.vim ${_user_home}/.vim_backup; \
                mv ${_user_home}/.vimrc ${_user_home}/.vimrc_backup ",
    unless  => "test \"`cd ${_user_home}/.vim ; git config --get \
                remote.origin.url`\" = ${_vimrc_url}",
    }
  ->
  # Install vimrc along with submodule init
  vcsrepo { "${_user_home}/.vim":
    ensure     => present,
    provider   => git,
    source     => $_vimrc_url,
    submodules => $_git_clone_ssh
  }
  ->
  # Setup .vimrc file
  file {"${_user_home}/.vimrc":
    content => template('vim_puppet/vimrc.erb'),
  }

  # Init submodule if cloned using https
  if !$_git_clone_ssh {
    exec { 'Replace all git: to https:':
      command => "sed -i -- \'s/git:/https:/g\' ${_user_home}/.vim/.gitmodules",
      onlyif  => "grep git: ${_user_home}/.vim/.gitmodules",
      require => File["${_user_home}/.vimrc"],
    }
    ~>
    exec { 'Update Submodules':
      command   => 'git submodule update --init --recursive',
      cwd       => "${_user_home}/.vim",
      logoutput => true,
    }
  }
}
