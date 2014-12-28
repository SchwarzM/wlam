module WLAM

  class SvnAddon
    def initialize(name, options)
      @name = name
      @options = options
    end

    def update 
      WLAM.log.debug("Checkout svn #{@name}")
      if Dir.exist? File.join(@options[:root], @name)
        fetch
      else
        clone
      end
    end

    def versions
      WLAM.log.debug("Versions svn #{@name}")
      text = WLAM::Command.execute("svn info --depth=immediates ^/tags")
      versions = text.scan(/^Path:\s(.*)$/)
      ret = []
      versions.each do |ver|
        version = Aversion.normalize_version(ver.first)
        begin
          v = Gem::Version.new(version)
          ret << Aversion.new(ver.first, v) unless @options[:ignore_version] && @options[:ignore_version].include?(v.to_s)
        rescue ArgumentError
          WLAM.log.warn("Discarding #{ver.first} as unparseable please provide a parse option")
        end
      end
      ret
    end

    def clone
      Dir.chdir(@options[:root])
      WLAM::Command.execute("svn checkout #{@options[:source]} #{@name}")
    end

    def fetch
      Dir.chdir(File.join(@options[:root], @name))
      WLAM::Command.execute("svn update")
    end

  end

end
