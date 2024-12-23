CC = g++
CFLAGS = -Wall -g -std=c++20
SRCS = $(wildcard src/*.cpp)
PROGS = $(patsubst src/%.cpp,%,$(SRCS))


all: $(PROGS)

%: src/%.cpp
	$(CC) $(CFLAGS) -o exec/$@ $<
clean: 
	rm -f exec/$(PROGS)
