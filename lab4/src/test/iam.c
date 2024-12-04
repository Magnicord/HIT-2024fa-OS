#define __LIBRARY__

#include <errno.h>
#include <stdio.h>
#include <unistd.h>

_syscall1(int, iam, const char *, name);

int main(int argc, char *argv[]) {
    int result;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <name>\n", argv[0]);
        return 1;
    }

    result = iam(argv[1]);
    if (result == -1) {
        perror("iam");
        return 1;
    }

    return 0;
}
