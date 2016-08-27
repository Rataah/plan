# Logger
module Plan
  class << self
    def log
      @logger = Logger.new STDOUT if @logger.nil?
      @logger
    end
  end
end
