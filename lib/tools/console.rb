
module Plan
  class Console

    def initialize
      @cmdin = $stdin
      @cmdout = $stdout
    end

    def ask(message)
      puts message
      @cmdin.readline
    end

    def puts(message)
      @cmdout.puts message
    end
  end
end