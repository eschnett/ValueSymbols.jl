using ValueSymbols
using Test, Serialization

syms = [:car, :boat, :plane]
vsyms = map(ValueSymbol, syms)

@testset "ValueSymbols" begin
    @testset "Comparisons" begin
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
    end
    @testset "Chars" begin
        @test isbits(vsyms[1])

        io = IOBuffer()
        print(io, vsyms[1])
        @test String(take!(io)) == ":car"

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

        @test vsyms[1] <= vsyms[1]
        @test vsyms[1] > vsyms[2]
        @test vsyms[1] < vsyms[3]

        @test vsyms[1] <= syms[1]
        @test vsyms[1] > syms[2]
        @test vsyms[1] <vsyms[3]
    end

    @testset "Buffer" begin
        io = IOBuffer()
        Serialization.serialize(io, vsyms)
        seekstart(io)
        vsyms2 = Serialization.deserialize(io)
        for n in 1:length(vsyms2)
            @test vsyms2[n] === vsyms[n]
        end
    end

end
