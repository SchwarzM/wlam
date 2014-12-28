module WLAM
  module Client
    class Client < Thor

      def initialize(*args)
        super
        if WLAM.log.nil?
          WLAM.log = Logger.new(STDOUT)
        end
      end

      desc "update", "updates the addons from the WAddfile"
      def update
        a = WLAM::Dsl.evaluate('WAddfile', nil, nil)
        a.addons.each do |addon|
          addon.update
          WLAM.log.debug(addon.versions.sort.last)
        end
      end

    end
  end
end
