require 'forwardable'

module WLAM
  class Addon
    extend Forwardable


    def initialize(name, options)
      @name = name
      @options = options
      @options[:root] = File.join(Dir.pwd, '.wadd')
      Dir.mkdir @options[:root] unless Dir.exist? @options[:root]
      case @options[:type]
      when :git
        @impl = GitAddon.new(@name, @options)
      when :svn
        @impl = SvnAddon.new(@name, @options)
      else
        fail "unknown addon type #{@options[:type]}"
      end
    end

    def to_s
      "#{@name}: #{@options[:source]}, #{@options[:type]}"
    end
    
    def_delegators :@impl, :update, :versions

  end
end
