module Geometry

import Base.show
import Base.==

using CairoMakie
CairoMakie.activate!()
Makie.inline!(true)

using Test

export Point2D, Point3D, Polygon, distance, isRectangular, area, perimeter, convert_arguments

"""
  Point2D(x::Real, y::Real)
  Point2D(points::String)

Create a Point2D (a point in 2 dimensional space) from either a 2 reals or a string in the format "(x,y)".  
The argument for `Point2D` can be 2 reals or a string in the format "(x,y)".

# Examples
```julia-repl
julia> Point2D(1,2)
(1,2)

julia> Point2D("(10,20)")
(10,20)
```
"""
struct Point2D
    x::Real
    y::Real

    function Point2D(x::Real, y::Real)
        new(x,y)
    end
    function Point2D(point::String)
        point = split(point, ",")
        x = point[1][2:end]
        y = point[2][1:end-1]

        if occursin(".", x)
            x = parse(Float64, x)
        else
            x = parse(Int, x)
        end
        if occursin(".", y)
            y = parse(Float64, y)
        else
            y = parse(Int, y)
        end
        Point2D(x,y)
    end
end

Base.show(io::IO, p::Point2D) = print("(", p.x, ",", p.y, ")")
==(p1::Point2D, p2::Point2D) = (p1.x == p2.x) && (p1.y == p2.y)

"""
  Distance(p1::Point2D, p2::Point2D)

Returns a float representing the distance between two Points2D's.  
The argument for `Distance` can be 2 Point2D's.

# Examples
```julia-repl
julia> Distance(Point2D(0,0), Point2D(0,1))
1

julia> Distance(Point2D(1,0), Point2D(10,0))
9
```
"""
distance(p1::Point2D, p2::Point2D) = sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)

"""
  Point3D(x::Real, y::Real, z::Real)

Create a Point3D (a point in 3 dimensional space) from 3 reals.  
The argument for `Point3D` must be 3 reals.

# Examples
```julia-repl
julia> Point2D(1,2,3)
(1,2,3)
```
"""
struct Point3D
    x::Real
    y::Real
    z::Real
end

Base.show(io::IO, p::Point3D) = print("(", p.x, ",", p.y, ",", p.z, ")")
==(p1::Point3D, p2::Point3D) = p1.x == p2.x && p1.y == p2.y && p1.z == p2.z

"""
  distance(p1::Point2D, p2::Point2D)

Returns a float representing the distance between two Points3D's.  
The argument for `distance` can be 2 Point3D's.

# Examples
```julia-repl
julia> distance(Point3D(0,0,0), Point3D(0,0,1))
1

julia> distance(Point3D(1,0,0), Point3D(1,1,0))
sqrt(2)
```
"""
distance(p1::Point3D, p2::Point3D) = sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2 + (p2.z - p1.z)^2)

"""
  Polygon(points::Vector{Point2D})
  Polygon(points::Vector{Real})
  Polygon(points::Real ...)

Create a Polygon (set of 2 dimensional points) from either a vector of Point2D's, a Vector of Reals or any even number of reals.  
The argument for `Polygon` can be a Vector of Point2D's or a Vector of Reals (if the number of reals lis even).

# Examples
```julia-repl
julia> Polygon([Point2D(1,2),Point2D(3,4),Point2D(5,6)])
[(1,2), (3,4), (5,6)]

julia> Polygon([11,22,33,44,55,66])
[(11,22), (33,44), (55,66)]

julia> Polygon(15,25,35,45,55,65)
[(15,25), (35,45), (55,65)]
```
"""
struct Polygon
    points::Vector{Point2D}

    function Polygon(points::Vector{Point2D})
        length(points) >= 3 || throw(ArgumentError("There must be at least 3 points to make a polygon."))
        new(points)
    end
    
    function Polygon(points::Vector{T}) where T <: Real
        length(points) % 2 == 0 || throw(ArgumentError("There must be an even number of Reals"))
        p = Point2D[]
        for i in 1:2:length(points)
            temp = Point2D(points[i], points[i + 1])
            push!(p, temp)
        end
        Polygon(p)
    end
    function Polygon(points::Real ...)
        p = Real[]
        map(temp->append!(p, temp), points)
        Polygon(p)
    end
end

function Base.show(io::IO, p::Polygon)
    output = "{"
    for i in p.points
        if i != p.points[end]
            output *= string("(", i.x, ",", i.y, "), ")
        else
            output *= string("(", i.x, ",", i.y, ")}")
        end
    end
    print(output)
end

==(p1::Polygon, p2::Polygon) = p1.points == p2.points

"""
  perimeter(p::Polygon)

Returns a float representing the total perimeter of a Polygon.  
The argument for `perimeter` must be a Polygon.

# Examples
```julia-repl
julia> perimeter(Polygon([Point2D(0,0),Point2D(1,1), Point2D(0,1)]))
2+sqrt(2)

julia> perimeter(Polygon([Point2D(0,0),Point2D(1,0),Point2D(1,1), Point2D(0,1)]))
4
```
"""
function perimeter(p::Polygon)
    total = 0
    for i in 2:length(p.points)
        total += distance(p.points[i - 1], p.points[i])
    end
    total += distance(p.points[1], p.points[end])
    total
end

"""
  isRectangular(p::Polygon)

Returns a boolean representing whether the Polygon is a rectangle.  
The argument for `isRectangular` must be a Polygon

# Examples
```julia-repl
julia> isRectangular(Polygon([Point2D(0,0),Point2D(1,1), Point2D(0,1)]))
false

julia> isRectangular(Polygon([Point2D(0,0),Point2D(1,0),Point2D(1,1), Point2D(0,1)]))
true
```
"""
function isRectangular(p::Polygon)
    if length(p.points) != 4
        return false
    end
    return isapprox(distance(p.points[1], p.points[3]),distance(p.points[2], p.points[4]))
end

Makie.plottype(::Polygon) = Makie.Lines

function Makie.convert_arguments(S::Type{<:Lines}, p::Polygon)
    xpts = map(pt->pt.x, p.points)
    append!(xpts, p.points[1].x)
    ypts = map(pt->pt.y, p.points)
    append!(ypts, p.points[1].y)
    Makie.convert_arguments(S, xpts, ypts)
end

end #end of module