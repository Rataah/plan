module Plan
  # Pool of symbol
  class SymbolPool
    def store(symbol)
      pool[symbol.name] = symbol if symbol.name
    end

    def contains?(symbol_name)
      pool.key? symbol_name
    end

    def [](symbol_name)
      pool[symbol_name]
    end

    def all
      pool.values
    end

    def each
      pool.each_value do |value|
        yield value
      end
    end

    private_class_method

    def self.[](floor)
      @pools ||= {}

      unless @pools.key?(floor)
        Plan.log.debug("New symbol pool for floor #{floor.name}")
        @pools[floor] = SymbolPool.new(floor)
      end
      @pools[floor]
    end

    private

    def initialize(floor)
      @floor = floor
    end

    def pool
      @symbol_pool ||= {}
    end
  end
end
