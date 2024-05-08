# Ovo je primjer komentara
# U novom redu imamo primjer kreiranja varijabli

CC = gcc
CFLAGS = -c -Wall

# target: all sada ima dependencies

all: fpgaloader

fpgaloader: fpgaloader.o 
	$(CC) fpgaloader.o -o fpgaloader
	ls -l fpgaloader
	
clean:
	rm *.o fpgaloader
