module ValueSymbols

export ValueSymbol
immutable ValueSymbol
    ptr::UInt
    ValueSymbol(sym::Symbol) = new(Ptr{Cchar}(Cstring(sym)))
end

function Base.convert(::Type{Symbol}, vsym::ValueSymbol)
    Symbol(unsafe_wrap(String, Ptr{Cchar}(vsym.ptr)))
end

Base.promote_rule(::Type{ValueSymbol}, ::Type{Symbol}) = ValueSymbol



# Output
Base.show(io::IO, vsym::ValueSymbol) = show(io, convert(Symbol, vsym))



# Equality is based on pointer comparison
Base.:(==)(vsym1::ValueSymbol, vsym2::ValueSymbol) = vsym1.ptr == vsym2.ptr
Base.:(==)(vsym1::ValueSymbol, sym2::Symbol) = vsym1 == ValueSymbol(sym2)
Base.:(==)(sym1::Symbol, vsym2::ValueSymbol) = ValueSymbol(sym1) == vsym2.ptr
# Ordering is also based on pointer comparison
# Note: This differs from the ordering of symbols, which depends on their value
Base.isless(vsym1::ValueSymbol, vsym2::ValueSymbol) = vsym1.ptr < vsym2.ptr
Base.isless(vsym1::ValueSymbol, sym2::Symbol) = vsym1 < ValueSymbol(sym2)
Base.isless(sym1::Symbol, vsym2::ValueSymbol) = ValueSymbol(sym1) < vsym2

function Base.serialize(ser::AbstractSerializer, vsym::ValueSymbol)
    Base.serialize_type(ser, ValueSymbol)
    write(ser.io, Symbol(vsym))
end

function Base.deserialize(ser::AbstractSerializer, ::Type{ValueSymbol})
    ValueSymbol(read(ser.io, Symbol))
end

end
