# ValueSymbols

[![Build Status](https://travis-ci.org/eschnett/ValueSymbols.jl.svg?branch=master)](https://travis-ci.org/eschnett/ValueSymbols.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/wvi75rjjgdueribo/branch/master?svg=true)](https://ci.appveyor.com/project/eschnett/valuesymbols-jl/branch/master)
[![Coverage Status](https://coveralls.io/repos/eschnett/ValueSymbols.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/eschnett/ValueSymbols.jl?branch=master)
[![codecov.io](http://codecov.io/github/eschnett/ValueSymbols.jl/coverage.svg?branch=master)](http://codecov.io/github/eschnett/ValueSymbols.jl?branch=master)

The module `ValueSymbols` provides a wrapper type `ValueSymbol` for
Julia Symbols, implemented as pointerfree "bitstype". This allows
storing `ValueSymbol` objects very efficiently in immutable types or
tuples with other bitstype types. Regular `Symbol` objects are stored
as pointers, hence are not bitstypes, and hence currently require heap
allocation.

```Julia
using ValueSymbols
sym = :car
isbits(sym)
vsym = ValueSymbol(sym)
isbits(vsym)
```
`ValueSymbol` is a bitstype, while `Symbol` is not.

This is the practical consequence:
```Julia
@time Pair{Symbol,Int}[:car => i for i in 1:1000000];
  0.082046 seconds (1.00 M allocations: 38.147 MB, 79.57% gc time)

@time Pair{ValueSymbol,Int}[ValueSymbol(:car) => i for i in 1:1000000];
  0.006780 seconds (2 allocations: 15.259 MB)
```
Creating tuples or pairs containing symbols requires one heap
allocation per tuple or pair. If you use a `ValueSymbol` instead,
these allocations are avoided.

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

Value symbols also define an ordering. This ordering is based on the
symbols' name, same as for Julia's regular symbols:
```Julia
@assert :car < :plane
@assert ValueSymbol(:car) < ValueSymbol(:plane)
```
