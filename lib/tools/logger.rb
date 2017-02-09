# Logger method for Plan module.
module Plan
  class << self
    def configure_logger(verbose = false)
      Plan.log.level = verbose ? Logger::DEBUG :   Logger::INFO
      Plan.log.formatter = proc { |_, _, _, msg| "*#{msg}\n" }
    end

    def log
      @logger ||= Logger.new STDOUT
    end
  end
end
