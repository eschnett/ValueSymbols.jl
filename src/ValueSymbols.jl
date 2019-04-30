module ValueSymbols

using Serialization

struct ValueSymbol
    ptr::UInt
    ValueSymbol(sym::Symbol) = new(pointer_from_objref(sym))
end

Base.convert(::Type{Symbol}, vsym::ValueSymbol) =
    unsafe_pointer_to_objref(reinterpret(Ptr{Nothing}, vsym.ptr))
Base.convert(::Type{String}, vsym ::ValueSymbol) =
    String(convert(Symbol,vsym))

Base.promote_rule(::Type{ValueSymbol}, ::Type{Symbol}) = ValueSymbol

# Output
Base.show(io::IO, vsym::ValueSymbol) = show(io, convert(Symbol, vsym))

# Equality is based on pointer comparison
Base. ==(vsym1::ValueSymbol, vsym2::ValueSymbol) = vsym1.ptr == vsym2.ptr
Base. ==(vsym1::ValueSymbol, sym2::Symbol) = vsym1 == ValueSymbol(sym2)
Base. ==(sym1::Symbol, vsym2::ValueSymbol) = ValueSymbol(sym1) == vsym2.ptr

Base.isless(vsym1::ValueSymbol, vsym2::ValueSymbol) =
    isless(convert(String, vsym1), convert(String, vsym2))

Base.isless(vsym1::ValueSymbol, sym2::Symbol) = vsym1 < ValueSymbol(sym2)
Base.isless(sym1::Symbol, vsym2::ValueSymbol) = ValueSymbol(sym1) < vsym2


function Serialization.serialize(ser::AbstractSerializer, vsym::ValueSymbol)
    Serialization.serialize_type(ser, ValueSymbol)
    write(ser.io, Symbol(vsym))
end

function Serialization.deserialize(ser::AbstractSerializer, ::Type{ValueSymbol})
    ValueSymbol(read(ser.io, Symbol))
end

export ValueSymbol
end
