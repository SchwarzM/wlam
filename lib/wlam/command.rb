module WLAM
  class Command
    def self.execute(string)
      WLAM.log.debug("Command started #{string}")
      ret = ""
      status = Open4::popen4(string) do |pid, stdin, stdout, stderr|
        std = stdout.read.strip
        stde = stderr.read.strip
        std.split("\n").each {|line| WLAM.log.debug(line.strip) unless line.strip.empty?}
        stde.split("\n").each {|line| WLAM.log.debug(line.strip) unless line.strip.empty?}
        ret = std
      end
      WLAM.log.error("Command failed: #{string}") if status.exitstatus != 0
      WLAM.log.debug("Command exited #{string} status #{status.inspect}")
      ret
    end
  end
end
