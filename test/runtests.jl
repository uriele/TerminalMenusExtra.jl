#using .TerminalMenusExtra
using Test

#cd("test")
include("../src/utilities.jl")

@testset "TerminalMenusExtra" begin
    # Write your tests here.
    @testset "utilities" begin

        existing_dir = "../test_utilities"
        missing_dir = "../missing_dir"
        existing_file = "../test_utilities/test_file.txt"
        existing_dirlink = "../test_utilities/link_test_folder"
        existing_filelink = "../test_utilities/link_test_file.txt"
        linked_folder = "../test_utilities/linked_folder"


        @test  _isdir(missing_dir)==false
        @test _isdir(missing_dir) == false
        @test _isfile(missing_dir) == false
        @test _islinkfile(existing_file) == false
        @test _islinkdir(existing_dir) == false
        @test _islinkfile(existing_filelink) == true
        @test _islinkdir(existing_dirlink) == true
        @test _readdir(existing_dir) == readdir(existing_dir)
        @test _readdir(existing_dirlink) == readdir(linked_folder)

        @test _ordered_dirvector(existing_dir) == [".", "..", "link_test_folder", "linked_folder", "link_test_file.txt", "test_file.txt"]
        @test _ordered_dirvector(existing_dir)[1:2] == [".", ".."]
        @test _ordered_dirvector("/")[1] == "."
        @test _ordered_dirvector("/")[2] != ""
        
    end
end
