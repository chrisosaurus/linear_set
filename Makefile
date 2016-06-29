.POSIX:

include config.mk

SRC = linear_set.c
OBJ = ${SRC:.c=.o}

EXTRAFLAGS =

# default to error all: linear_set 
%.o: %.c
	@echo COMPILING CC $< with extra flags \"${EXTRAFLAGS}\"
	@${CC} -g -c ${CFLAGS} $< ${EXTRAFLAGS} -o $@

linear_set: ${OBJ}
	@echo "ERROR: unable to compile linear_set on it's own as it is a library"
	exit 1

cleanobj:
	@echo cleaning objects and temporary files
	@find . -iname '*.o' -delete

clean: cleanobj
	@echo cleaning tests
	@rm -f test_ls
	@rm -f example
	@echo cleaning gcov guff
	@find . -iname '*.gcda' -delete
	@find . -iname '*.gcov' -delete
	@find . -iname '*.gcno' -delete


test: run_tests

run_tests: compile_tests
	@echo -e "\n\nrunning test_ls"
	./test_ls
	@echo -e "\n"

compile_tests: clean ${OBJ}
	@echo "compiling tests"
	@${CC} test_linear_set.c -o test_ls ${LDFLAGS} ${OBJ}
	@make -s cleanobj

example: clean ${OBJ}
	@echo "compiling and running example"
	@${CC} example.c -o example ${LDFLAGS} ${OBJ}
	./example

.PHONY: all clean cleanobj linear_set test example

