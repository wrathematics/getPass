CC = gcc
CPPFLAGS = -Wall -pedantic -Wextra
LDFLAGS = -lX11

all: clean getPass

getPass:
	$(CC) getPass.c $(CPPFLAGS) $(LDFLAGS) -o getPass

clean:
	rm -rf getPass
