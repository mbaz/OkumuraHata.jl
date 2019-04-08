using Test
using OkumuraHata

@testset "Pass expected" begin
    l = loss_oh(500,1,30,2)
    @test trunc(Int,l[:large_city]*1000) == 118695
    @test trunc(Int,l[:small_city]*1000) == 118613
    @test trunc(Int,l[:suburban]*1000) == 110079
    @test trunc(Int,l[:rural]*1000) == 92326
end

@testset "Failure expected" begin
    @test_throws ErrorException loss_oh(50,1,30,2)
    @test_throws ErrorException loss_oh(1600,1,30,2)
    @test_throws ErrorException loss_oh(500,0.5,30,2)
    @test_throws ErrorException loss_oh(500,11,30,2)
    @test_throws ErrorException loss_oh(500,5,29,2)
    @test_throws ErrorException loss_oh(500,5,301,2)
    @test_throws ErrorException loss_oh(500,5,100,0.5)
    @test_throws ErrorException loss_oh(500,5,100,11)
end
