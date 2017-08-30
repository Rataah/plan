module Plan
  class PowerOutlet < WallSymbol
    SYMBOL = 'symbol-power-outlet'.freeze

    private

    def symbol
      SYMBOL
    end
    
    def rotate?
      false
    end
  end
end
