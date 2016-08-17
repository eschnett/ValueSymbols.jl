# ValueSymbols

[![Build Status](https://travis-ci.org/eschnett/ValueSymbols.jl.svg?branch=master)](https://travis-ci.org/eschnett/ValueSymbols.jl)
[![Coverage Status](https://coveralls.io/repos/eschnett/ValueSymbols.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/eschnett/ValueSymbols.jl?branch=master)
[![codecov.io](http://codecov.io/github/eschnett/ValueSymbols.jl/coverage.svg?branch=master)](http://codecov.io/github/eschnett/ValueSymbols.jl?branch=master)

The module `ValueSymbols` provides a wrapper type `ValueSymbol` for
Julia Symbols, implemented as pointerfree "bitstype". This allows
storing `ValueSymbol` objects very efficiently in immutable types or
tuples with other bitstype types. Regular `Symbol` objects are stored
as pointers, hence are not bitstypes, and hence currently require heap
allocation.

## Examples

Convert between symbols and value symbols:
```Julia
using ValueSymbols
sym = :car
vsym = ValueSymbol(sym)
sym2 = Symbol(vsym)
@assert sym2 === sym
```
Converting to a value symbol and back gives the original symbol.

Comparisons:
```Julia
using ValueSymbols
sym = :car
vsym = ValueSymbol(sym)
@assert vsym == sym
```
Value symbols and symbols can be compared directly. Note that this
works only with the regular comparison operator `==`, not with the
object identity comparison `===`, as the latter is always different
for different types.

Value symbols also define an ordering. This ordering is based on
implementation details, not on the symbol's string representation.
Their ordering is thus different from Julia's regular symbols.
```Julia
@assert :car < :plane
@assert (ValueSymbol(:car) < ValueSymbol(:plane) ||
         ValueSymbol(:car) > ValueSymbol(:plane))
```
`:car < :plane` is always true; for the respective value symbols,
things can go either way.
