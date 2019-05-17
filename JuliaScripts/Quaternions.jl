# Implementation of quaternions and functions to rotate points in R3

# Base functions to be extended
import Base.+, Base.*, Base.conj, Base.inv, Base.zero, Base.one, Base.-, Base.==
import Base.show, Base./, Base.isapprox

#-------------------------------------------------------------------------------

"""Define Quaternions"""
mutable struct Quaternion{T <: Real}
    scalar :: T
    x :: T
    y :: T
    z :: T
end

# Basic operations on quaternions

"""Equality of Quaternions"""
==(a::Quaternion, b::Quaternion) = (a.scalar==b.scalar)&&(a.x==b.x)&&(a.y==b.y)&&(a.z==b.z);

"""Approximate equality of quaternions"""
isapprox(a::Quaternion, b::Quaternion) = isapprox(a.scalar,b.scalar)&&isapprox(a.x,b.x)&&isapprox(a.y,b.y)&&isapprox(a.z,b.z)

"""Quaternion output on screen"""
function show(io::IO, a::Quaternion)
    println("$(a.scalar) + $(a.x)i + $(a.y)j + $(a.z)k")
end

"""We can add Quaternions of the same type"""
+(a::Quaternion{T}, b::Quaternion{T}) where {T <: Real} = Quaternion{T}(a.scalar + b.scalar,
    a.x + b.x, a.y + b.y, a.z + b.z);

"""Add a quaternion and a real number"""
+(a::Quaternion{T}, r::T) where {T <: Real} = Quaternion{T}(a.scalar + r, a.x, a.y, a.z);
+(r::T, a::Quaternion{T}) where {T <: Real} = +(a,r);

"""Subtract quaternions of the same type"""
-(a::Quaternion{T}, b :: Quaternion{T}) where {T <: Real} = Quaternion{T}(a.scalar - b.scalar,
    a.x - b.x, a.y - b.y, a.z - b.z)

-(a::Quaternion{T}) where {T <: Real} = Quaternion{T}(-a.scalar, -a.x, -a.y, -a.z)

"""Conjugate a Quaternion"""
conj(a::Quaternion{T}) where {T <: Real} = Quaternion{T}(a.scalar, -a.x, -a.y, -a.z);

"""Quaternion product"""
*(a::Quaternion{T}, b::Quaternion{T}) where {T <: Real} = Quaternion{T}(
    a.scalar*b.scalar - a.x*b.x - a.y*b.y - a.z*b.z,
    a.scalar*b.x + a.x*b.scalar + a.y*b.z - a.z*b.y,
    a.scalar*b.y - a.x*b.z + a.y*b.scalar + a.z*b.x,
    a.scalar*b.z + a.x*b.y - a.y*b.x + a.z*b.scalar
);

"""Multiply quaternion by real number"""
*(a::Quaternion{T}, r::T) where {T <: Real} = Quaternion{T}(a.scalar*r, a.x*r, a.y*r, a.z*r);
*(r::T, a::Quaternion{T}) where {T <: Real} = *(a,r);

"""Quaternion zero and one"""
zero(a::Quaternion{T}) where {T <: Real} = Quaternion{T}(zero(T), zero(T), zero(T), zero(T));
one(a::Quaternion{T}) where {T <: Real} = Quaternion{T}(one(T), zero(T), zero(T), zero(T));

"""Invert a Quaternion"""
function inv(a::Quaternion{T}) where {T <: Real}
    
    if a == zero(a)
        error("Can't invert zero!")
    else
        return conj(a)*(1/(a.scalar^2 + a.x^2 + a.y^2 + a.z^2))
    end
end

"""Quaternion division"""
/(a::Quaternion{T}, b::Quaternion{T}) where{T <: Real} = a*inv(b)
    
"""Division by scalar"""
/(a::Quaternion{T}, r::T) where {T <: Real} = Quaternion{T}(a.scalar/r, a.x/r, a.y/r, a.z/r)
/(a::Quaternion{T}, r::T) where {T <: Integer} = Quaternion(a.scalar/r, a.x/r, a.y/r, a.z/r)

"""Obtain vector and scalar parts of a Quaternion"""
vectorpart(a::Quaternion{T}) where {T <: Real} = [a.x,a.y,a.z]
scalarpart(a::Quaternion{T}) where {T <: Real} = a.scalar
    
"""Convert vector or scalar to Quaternion"""
function quaternion(a::Array{T,1}) where {T <: Real}
    if length(a) == 3
        return Quaternion{T}(zero(a[1]), a[1], a[2], a[3])
    elseif length(a) == 4
        return Quaternion{T}(a[1], a[2], a[3], a[4])
    else
        error("Vector must be of length 3 or 4 to convert to Quaternion")
    end
end

quaternion(a::T) where {T <: Real} = Quaternion{T}(a, zero(a), zero(a), zero(a))

"""Rotate a point in R3 about an axis by a given angle using quaternions."""
function rotateaxis(point::Array{T,1}, 
                    axis::Array{T,1},
                    angle::T) where {T <: AbstractFloat}
                
    if (length(axis) == 3) && (length(point) == 3)
        axisnorm::T = sqrt(sum(axis.^2))
        two::T = one(T) + one(T)
        rot::Quaternion{T} = Quaternion{T}(
            cos(angle/two),
            sin(angle/two)*axis[1]/axisnorm,
            sin(angle/two)*axis[2]/axisnorm,
            sin(angle/two)*axis[3]/axisnorm
            )
        
        return vectorpart(rot * quaternion(point) * conj(rot))
    else
        error("Point and axis must live in R3!")
    end
end;
                
                