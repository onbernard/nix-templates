CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -O2
TARGET := hello
SRC := main.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $@ $^

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
