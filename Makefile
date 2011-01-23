CFLAGS=-O


all: shortest-path


shortest-path: shortest-path.c
	gcc $(CFLAGS) -o shortest-path shortest-path.c


test: shortest-path input-ref-littleendian output-ref input-bench-littleendian output-bench
	./shortest-path < input-ref-littleendian | diff -u - output-ref
	./shortest-path < input-bench-littleendian | diff -u - output-bench


#bench:
    #TODO

.PHONY: clean test

clean:
	rm -f ./shortest-path

