module WLAM
  class GitAddon
  
    def initialize(name, options)
      @name = name
      @options = options
    end

    def update
      puts "Checkout git #{@name}"
      if Dir.exist? File.join(@options[:root], @name)
        fetch
      else
        clone
      end
    end

    def versions
      puts "Versions git #{@name}"
      text = `git tag -l`
      versions = text.split(/\n/)
      ret = []
      versions.each do |ver|
        version = Aversion.normalize_version(ver)
        begin
          v = Gem::Version.new(version)
          ret << Aversion.new(ver, v)
        rescue
          puts "Discarding #{ver} as unparseable please provide a parse option"
        end
      end
      ret
    end

    def clone
      Dir.chdir(@options[:root])
      `git clone #{@options[:source]} #{@name}`
    end

    def fetch
      Dir.chdir(File.join(@options[:root], @name))
      `git fetch --tags`
    end

  end
end
