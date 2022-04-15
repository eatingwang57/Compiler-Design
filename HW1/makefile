CC = gcc
CFLAGS = -o
TARGET = scanner

all: $(TARGET)

lex.yy.c: scanner.l
	flex $(TARGET).l

$(TARGET): lex.yy.c
	$(CC) $(CFLAGS) $@ $? -lfl


clean:
	rm -f $(TARGET)