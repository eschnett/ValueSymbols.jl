using ValueSymbols
using Base.Test

syms = [:car, :boat, :plane]
@test !isbits(syms[1])

@test syms[1] === :car
@test syms[2] !== :car
@test syms[3] !== syms[2]
@test syms[1] == :car
@test syms[2] != :car
@test syms[3] != syms[2]

@test syms[1] <= syms[1]
@test syms[1] > syms[2]
@test syms[1] < syms[3]



vsyms = map(ValueSymbol, syms)
@test isbits(vsyms[1])

io = IOBuffer()
print(io, vsyms[1])
@test takebuf_string(io) == ":car"

@test vsyms[1] === ValueSymbol(:car)
@test vsyms[2] !== ValueSymbol(:car)
@test vsyms[3] !== vsyms[2]
@test vsyms[1] == ValueSymbol(:car)
@test vsyms[2] != ValueSymbol(:car)
@test vsyms[3] != vsyms[2]

# ValueSymbol and Symbol are different types, so comparing them via
# `===` is always false
@test vsyms[1] !== :car
@test vsyms[2] !== :car
@test vsyms[3] !== vsyms[2]

@test vsyms[1] == :car
@test vsyms[2] != :car
@test vsyms[3] != vsyms[2]

@test syms[1] <= vsyms[1]
@test vsyms[1] <= syms[1]
sort!(vsyms)
@test vsyms[1] < vsyms[2]
@test vsyms[2] < vsyms[3]
@test vsyms[1] < vsyms[3]       # transitivity



io = IOBuffer()
serialize(io, vsyms)
vsyms2 = deserialize(IOBuffer(takebuf_array(io)))
for n in 1:length(vsyms2)
    @test vsyms2[n] === vsyms[n]
end
