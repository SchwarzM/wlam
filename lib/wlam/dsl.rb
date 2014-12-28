require 'wlam'

module WLAM
    class Dsl

      attr_reader :addons

      def initialize
        @addons = []
      end

      def self.evaluate(addfile, lockfile, unlock)
        builder = new
        builder.eval_addfile(addfile)
        builder.to_definition(lockfile, unlock)
        builder
      end

      def eval_addfile(addfile)
        contents ||= File.read(addfile)
        instance_eval(contents, addfile.to_s, 1)
      end

      def to_definition(lockfile, unlock)
      end

      def addon(name, opts = {})
        opts[:source] ||= scrape(name)
        case 
        when opts[:source].start_with?('git')
          opts[:type] = :git
        when opts[:source].start_with?('svn')
          opts[:type] = :svn
        else
          fail "Could not determine type for #{opts[:source]}"
        end
        @addons << Addon.new(name, opts)
      end

      def scrape(name)
        WLAM.log.info("Trying to scrape repository for #{name}")
        response = open("http://wow.curseforge.com/addons/#{name}/repositories/mainline").read
        matches = git_links(response)
        return matches[1] unless matches.nil?
        matches = svn_links(response)
        return matches[1] unless matches.nil?
        fail "No matching source url found for #{name} aborting"
      end

      def git_links(text)
        WLAM.log.debug("Searching for git links ...")
        matches = /(git:\/\/.*\.git)/.match text
      end

      def svn_links(text)
        WLAM.log.debug("Searching for svn links ...")
        matches = /(svn:\/\/.*)</.match text
      end
  end
end
