cmake_minimum_required(VERSION 3.8.2)
project(c)

set(CMAKE_CXX_STANDARD 98)

add_executable(c main.cpp sha256.cpp sha256.h common.cpp common.h)