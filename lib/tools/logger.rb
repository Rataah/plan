module Plan
  class << self
    def log
      if @logger.nil?
        @logger = Logger.new STDOUT
      end
      @logger
    end
  end
end