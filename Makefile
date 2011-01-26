CFLAGS=


all: shortest-path


shortest-path: shortest-path.c
	gcc $(CFLAGS) -O -o shortest-path shortest-path.c

shortest-path-O3: shortest-path.c
	gcc $(CFLAGS) -O3 -o shortest-path shortest-path.c

test: shortest-path input-ref-littleendian output-ref input-bench-littleendian output-bench
	./shortest-path < input-ref-littleendian | diff -u - output-ref
	./shortest-path < input-bench-littleendian | diff -u - output-bench


bench: shortest-path
	papiex -e PAPI_TOT_CYC -e PAPI_TOT_INS -e PAPI_BR_MSP shortest-path < input-bench-littleendian >/dev/null

bench-O3: shortest-path-O3
	papiex -e PAPI_TOT_CYC -e PAPI_TOT_INS -e PAPI_BR_MSP shortest-path < input-bench-littleendian >/dev/null


.PHONY: clean test

clean:
	rm -f ./shortest-path
	rm ./shortest-path.papiex*
