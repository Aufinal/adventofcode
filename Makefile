CC = g++
CFLAGS = -Wall -g -std=c++20
VPATH = 2019
SRCS = $(wildcard */*.cpp)
PROGS = $(patsubst %.cpp,exec/%,$(SRCS))


all: $(PROGS)


%: %.cpp
	$(CC) $(CFLAGS) -o exec/$(subst /,-,$@) $<
clean: 
	rm -f $(PROGS)
