module WLAM

  class SvnAddon
    def initialize(name, options)
      @name = name
      @options = options
    end

    def update 
      puts "Checkout svn #{@name}"
      if Dir.exist? File.join(@options[:root], @name)
        fetch
      else
        clone
      end
    end

    def versions
      puts "Versions svn #{@name}"
      text = `svn info --depth=immediates ^/tags`
      versions = text.scan(/^Path:\s(.*)$/)
      ret = []
      versions.each do |ver|
        version = Aversion.normalize_version(ver.first)
        begin
          v = Gem::Version.new(version)
          ret << Aversion.new(ver.first, v)
        rescue ArgumentError
          puts "Discarding #{ver.first} as unparseable please provide a parse option"
        end
      end
      ret
    end

    def clone
      Dir.chdir(@options[:root])
      `svn checkout #{@options[:source]} #{@name}`
    end

    def fetch
      Dir.chdir(File.join(@options[:root], @name))
      `svn update`
    end

  end

end
