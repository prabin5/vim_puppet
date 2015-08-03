# == Class: vim_puppet
#
# Puppet class to install all require components to setup puppet development
# environment. It includes installation of curl, tar, git, vim plugins.
# puppet should be already installed in the system to be able to run 
# puppet apply. Therefore, it must be run as root user.
#
# ===PARAMATERS
#
# [* show_lint_warning *]
# Shows puppetlint warnings on vim if set to true, else only shows ERRORS
# Required, Default => true
#
# [* disable_puppet_parser *]
# Disables puppet parser validate checks if set to false.
# Required, Default => false
#
# [* disable_puppetlint *]
# Disables puppet-lint checks if set to false.
# Required, Default => false
#
# [* vimrc_url *]
# git URL to download vim plugins
# Required, Default => https://github.com/ricciocri/vimrc.git
#
# [* exec_path *]
# Exec path used by exec resource
# Required, Default => [ '/usr/local/bin/', '/bin/', '/usr/bin' ] 
#
# [* misc_packages *]
# Array list of other packages required during puppet development
# Required, Default => ['vim','curl','tar','git']
#
# === Examples
#
#  class { 'vim_puppet':}
#
# === Authors
#
# waymilky 
#
#
class vim_puppet(
  $show_lint_warning     = true,
  $disable_puppetlint    = false,
  $disable_puppet_parser = false,
  $vimrc_url             = 'https://github.com/ricciocri/vimrc.git',
  $exec_path             = [ '/usr/local/bin/', '/bin/', '/usr/bin' ],
  $misc_packages         = ['vim','curl','tar','git'],
){
  
  # Validate parameters
  validate_bool($show_lint_warning)
  validate_bool($disable_puppetlint)
  validate_bool($disable_puppet_parser)
  validate_string($vimrc_url)
  validate_array($exec_path)
  validate_array($misc_packages)

  # setup and configure vim plugin and packages install
  include vim_puppet::install

}
