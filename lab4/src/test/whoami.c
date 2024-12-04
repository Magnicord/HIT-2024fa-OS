#define __LIBRARY__

#include <errno.h>
#include <stdio.h>
#include <unistd.h>

_syscall2(int, whoami, char*, name, unsigned int, size);

#define MAX_NAME_LEN 23

int main() {
    char name[MAX_NAME_LEN + 1] = {0};
    int result = whoami(name, MAX_NAME_LEN + 1);

    if (result == -1) {
        perror("whoami");
        return 1;
    }

    printf("%s\n", name);
    return 0;
}
