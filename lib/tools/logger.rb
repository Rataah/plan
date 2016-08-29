# Logger method for Plan module.
module Plan
  class << self
    def log
      @logger ||= Logger.new STDOUT
    end
  end
end
