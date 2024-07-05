CXX = g++
CXXFLAGS = -g -std=c++23 -Wall

#SRCS = $(wildcard *.cpp)
SRCS1 =  main.cpp
OBJS1 = $(SRCS1:.cpp=.o)

SRCS2 = fixed_point_converter.cpp
OBJS2 = $(SRCS2:.cpp=.o)

TARGETS = ref_model converter

.PHONY: all ref_model converter run format clean

all: $(TARGETS) run

%.o: %.cpp
	@echo "> Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

ref_model: $(OBJS1)
	@echo "> Linking object files"
	$(CXX) $(CXXFLAGS) $(OBJS1) -o $@

converter: $(OBJS2)
	@echo "> Linking object files"
	$(CXX) $(CXXFLAGS) $(OBJS2) -o $@

run:
	@echo "> Running $(TARGET)"
	./ref_model
	./converter

format: $(SRCS)
	clang-format -i $^ --style=Google

clean:
	@echo "> Removing *.exe and *.o"
	rm -rf *.o *.exe *.txt $(TARGET)

