module WLAM
  class Aversion
    include Comparable

    attr_reader :version, :name

    def self.normalize_version(string)
      ret = string
      # skip leading 'v'
      ret.sub!(/^v(.*)/, '\1')
      # skip leading whitespace
      ret.sub!(/^\s+(.*)/,'\1')
      # replace spaces with dashes
      ret.sub!(/ /, '-')
      ret
    end

    def initialize(name, version)
      @version = version
      @name = name
    end

    def <=>(anOther)
      @version <=> anOther.version
    end

    def to_s
      "#{@name}: #{@version}"
    end

  end
end
