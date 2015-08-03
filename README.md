# vim_puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet](#setup)
    * [What puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet](#beginning-with-puppet)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Overview

Module to install basic packages (git, curl, vim, tar) and setup vim plugins
to be used for puppet development

## Module Description
Puppet class to install all require components to setup puppet development
environment. It includes installation of curl, tar, git, vim plugins.
puppet should be already installed in the system to be able to run
puppet apply. Therefore, it must be run as root user.

This module depends https://github.com/ricciocri/vimrc.git repository for
vim plugin installation.


## Setup
Using puppet module
puppet module install waymilky-vim_puppet

* Install with default parameters:
~~~
class {'vim_puppet': }
~~~
* Setup with specific parameters. Example: Disable puppet parser and disable lint warning on vim
~~~
 class {'vim_puppet':
   disable_puppet_parser => true,
   show_lint_warning     => false,
 }
 ~~~
* Standalone setup with default parameters :
~~~
puppet apply -e "class {'vim_puppet':}
~~~
### What puppet affects

* Packages    - git, vim, tar, curl
* Directories - /root/.vim   (Takes a backup of existing to /root/.vim_backup)
* Files       - /root/.vimrc (Takes a backup of existing to /root/.vimrc)
* Others      - More details in Reference section

### Setup Requirements **OPTIONAL**

Puppet should be already installed

## Usage

Class Parameters can be overridden for custom need

- [* disable_puppet_parser *]  
 Disables puppet parser validate checks if set to false.
 Required, Default => false

- [* disable_puppetlint *]
 Disables puppet-lint checks if set to false.
 Required, Default : false

- [* exec_path *] 
 Exec path used by exec resource
 Required, Default : [ '/usr/local/bin/', '/bin/', '/usr/bin' ]

- [* misc_packages *]
 Array list of other packages required during puppet development
 Required, Default : ['vim','curl','tar','git']

## Reference
This project uses and is dependent on below excellent sources:

- [ricciocri](https://github.com/ricciocri/vimrc)
- [snipmate.vim](https://github.com/msanders/snipmate.vim.git)
- [syntastic](https://github.com/scrooloose/syntastic.git)
- [tabular](https://github.com/godlygeek/tabular.git)
- [vim-puppet](https://github.com/rodjek/vim-puppet.git)
- [vim-fugitive](https://github.com/tpope/vim-fugitive.git)
- [vim-markdown](https://github.com/plasticboy/vim-markdown)
- [nerdtree](https://github.com/scrooloose/nerdtree)
- [tcomment_vim](https://github.com/tomtom/tcomment_vim)

## TO DO
- Test cases
- ...
