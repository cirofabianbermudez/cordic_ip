CXX = g++
CXXFLAGS = -g -std=c++23 -Wall

#SRCS = $(wildcard *.cpp)
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)
TARGET = ref_model

.PHONY: run format clean

all: $(TARGET) run

%.o: %.cpp
	@echo "> Compiling $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	@echo "> Linking object files"
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(TARGET) 

run:
	@echo "> Running $(TARGET)"
	./$(TARGET) $(NUM)

format: $(SRCS)
	clang-format -i $^ --style=Google

clean:
	@echo "> Removing *.exe and *.o"
	rm -rf *.o *.exe *.txt $(TARGET)

