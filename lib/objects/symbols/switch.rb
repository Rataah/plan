module Plan
  class Switch < WallSymbol
    SYMBOLS = {
      simple: 'symbol-switch-simple',
      double: 'symbol-switch-double',
      two_way: 'symbol-switch-two-way',
      double_two_way: 'symbol-switch-double-two-way'
    }.freeze
    DEFAULT = :simple.freeze;

    private

    def symbol
      SYMBOLS.key?(@type) ? SYMBOLS[@type] : SYMBOLS[DEFAULT]
    end
  end
end
