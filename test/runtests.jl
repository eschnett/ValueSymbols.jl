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
        @test syms[1] != vsyms[1].ptr
        @test syms[2] != vsyms[1].ptr

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
        @test vsyms[1] < vsyms[3]

        @test vsyms[1] < syms[3]
        @test vsyms[2] < syms[3]
        @test vsyms[1] <= syms[1]
        @test vsyms[2] <= syms[3]

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

    @testset "Promotion" begin
        for i in syms, j in vsyms
            @test promote_rule(typeof(i), typeof(j)) == promote_rule(typeof(j), typeof(i)) == ValueSymbol
        end
    end

    @testset "Serialization" begin

        ser1 = Serializer(stdin)
        @test_broken 1 == 2

        ser2 = Serializer(stdout)
        @test 4 == Serialization.serialize(ser2, vsyms[1]) # outputs :car4
        @test 5 == Serialization.serialize(ser2, vsyms[2]) # outputs :boat4
        @test 6 == Serialization.serialize(ser2, vsyms[3]) # output :plane4
    end

end
