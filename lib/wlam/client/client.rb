module WLAM
  module Client
    class Client < Thor

      def initialize(*args)
        super
      end

      desc "update", "updates the addons from the WAddfile"
      def update
        a = WLAM::Dsl.evaluate('WAddfile', nil, nil)
        a.addons.each do |addon|
          addon.update
          puts addon.versions.sort.last
        end
      end

    end
  end
end
