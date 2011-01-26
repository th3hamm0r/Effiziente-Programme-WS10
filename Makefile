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

bench100: shortest-path tests.sh
	sh tests.sh 100

bench100-O3: shortest-path-O3 tests.sh
	sh tests.sh 100


.PHONY: clean test

clean:
	rm -f ./shortest-path
	rm ./shortest-path.papiex*
