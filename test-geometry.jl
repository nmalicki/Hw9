using .Geometry
using Test

pt2_1 = Point2D(1,1)
pt2_2 = Point2D(2,2)
pt2_3 = Point2D(1.1,2.2)
pt2_4 = Point2D(4.8,40.9)
pt2_5 = Point2D(10.11,10)

triangle = Polygon([Point2D(0,0), Point2D(1,1), Point2D(1,0)])
rectangle = Polygon([Point2D(0,0),Point2D(0,2), Point2D(1,2), Point2D(1,0)])
parallelogram = Polygon([Point2D(0,1),Point2D(0,3), Point2D(1,2), Point2D(1,0)])


@testset "Legal Point2D Default Constructor" begin
    @test isa(Point2D(1, 3), Point2D)
    @test isa(Point2D(10, 30), Point2D)
    @test isa(Point2D(1.2,2.8), Point2D)
    @test isa(Point2D(20.22,0.18), Point2D)
    @test isa(Point2D(1.2,2), Point2D)
end

@testset "Legal Point2D String Constructor" begin
    @test isa(Point2D("(10,89)"), Point2D)
    @test isa(Point2D("(0.2,1.239)"), Point2D)
    @test isa(Point2D("(2,1.239)"), Point2D)
end

@testset "Legal Point3D Default Constructor" begin
    @test isa(Point3D(1,2,3), Point3D)
    @test isa(Point3D(1.2,2.8,6.5), Point3D)
    @test isa(Point3D(1.2,2,1.1), Point3D)
end

@testset "Legal Polygon Constructor" begin
    @test isa(triangle, Polygon)
    @test isa(rectangle, Polygon)
    @test isa(parallelogram, Polygon)
end

@testset "Polygon Differnet Constructors" begin
    @test (Polygon([1,2,3,4,5,6]) == Polygon([Point2D(1,2), Point2D(3,4), Point2D(5,6)]))
    @test (Polygon(1,2,3,4,5,6) == Polygon([Point2D(1,2), Point2D(3,4), Point2D(5,6)]))
end

@testset "Distance" begin
    @test isapprox(distance(Point2D(0,0), Point2D(1,0)), 1)
    @test isapprox(distance(Point2D(10,0), Point2D(0,0)), 10)
    @test isapprox(distance(Point2D(0,0), Point2D(1,1)), sqrt(2))
end

@testset "Perimeter" begin
    @test isapprox(perimeter(triangle), 2+sqrt(2))
    @test isapprox(perimeter(rectangle), 6)
    @test isapprox(perimeter(parallelogram), 4+2sqrt(2))
end