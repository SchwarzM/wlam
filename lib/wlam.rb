require 'logger'
require 'open4'
require 'open-uri'
require 'uri'
require 'thor'
require 'wlam/command'
require 'wlam/version'
require 'wlam/aversion'
require 'wlam/dsl'
require 'wlam/client/client'
require 'wlam/addon'
require 'wlam/git_addon'
require 'wlam/svn_addon'

module WLAM
  def self.log
    @log
  end
  def self.log=(logger)
    @log = logger
  end
end
