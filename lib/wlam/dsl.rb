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

      def addon(name, *args)
        puts "Trying to scrape repository for #{name}"
        response = open("http://wow.curseforge.com/addons/#{name}/repositories/mainline").read
        matches = git_links(response)
        @addons << Addon.new(name, type: :git, source: matches[1]) unless matches.nil?
        if matches.nil?
          matches = svn_links(response)
          @addons << Addon.new(name, type: :svn, source:matches[1]) unless matches.nil?
        end
        fail "No matching source url found for #{name} aborting" if matches.nil?
      end        
      
      def git_links(text)
#        puts "Searching for git links ..."
        matches = /(git:\/\/.*\.git)/.match text
      end

      def svn_links(text)
#        puts "Searching for svn links ..."
        matches = /(svn:\/\/.*)</.match text
      end
  end
end
