cmake_minimum_required(VERSION 3.5)

project(cordic_ip
  VERSION 0.1
  LANGUAGES C CXX
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)
set(CMAKE_C_EXTENSIONS Off)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS Off)

add_executable(ref_model ref_model.cpp)
add_executable(fixed_point_converter fixed_point_converter.cpp)
add_executable(print_table print_table.cpp)

