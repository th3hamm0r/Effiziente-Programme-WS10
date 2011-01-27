CFLAGS=


all: shortest-path


shortest-path: remove-bin shortest-path.c
	gcc $(CFLAGS) -O -o shortest-path shortest-path.c
	
profile: remove-bin shortest-path.c
	gcc $(CFLAGS) -pg -O -o shortest-path shortest-path.c
	./shortest-path < input-bench-littleendian >/dev/null
	gprof ./shortest-path
	rm -f ./gmon.out


shortest-path-O3: remove-bin shortest-path.c
	gcc $(CFLAGS) -pg -O3 -o shortest-path shortest-path.c
	
profile-O3: remove-bin shortest-path.c
	gcc $(CFLAGS) -pg -O3 -o shortest-path shortest-path.c
	./shortest-path < input-bench-littleendian >/dev/null
	gprof ./shortest-path
	rm -f ./gmon.out


test: shortest-path input-ref-littleendian output-ref input-bench-littleendian output-bench
	./shortest-path < input-ref-littleendian | diff -u - output-ref
	./shortest-path < input-bench-littleendian | diff -u - output-bench


bench: remove-bin shortest-path
	papiex -e PAPI_TOT_CYC -e PAPI_TOT_INS -e PAPI_BR_MSP shortest-path < input-bench-littleendian >/dev/null

bench-O3: remove-bin shortest-path-O3
	papiex -e PAPI_TOT_CYC -e PAPI_TOT_INS -e PAPI_BR_MSP shortest-path < input-bench-littleendian >/dev/null

bench100: remove-bin shortest-path tests.sh
	sh tests.sh 100

bench100-O3: remove-bin shortest-path-O3 tests.sh
	sh tests.sh 100


.PHONY: clean test

remove-bin:
	rm -f ./shortest-path

clean: remove-bin
	rm -f ./shortest-path.papiex*
	rm -f ./gmon.out
