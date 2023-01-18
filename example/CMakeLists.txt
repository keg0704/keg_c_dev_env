cmake_minimum_required(VERSION 3.22)
project(example LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)

file(GLOB src "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
add_executable(example ${src})
target_include_directories(example PRIVATE include)
