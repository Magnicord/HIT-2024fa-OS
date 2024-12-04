#define __LIBRARY__  /* 启用内嵌的系统调用定义 */

#include <errno.h>   /* 用于处理错误码 */
#include <stdio.h>   /* 用于标准输入输出 */
#include <unistd.h>  /* 用于系统调用接口 */

_syscall2(int, whoami, char*, name, unsigned int, size);  /* 定义 whoami 系统调用 */

#define MAX_NAME_LEN 23  /* 定义最大名称长度为 23 */

int main() {
    char name[MAX_NAME_LEN + 1] = {0};  /* 定义用于存储名字的缓冲区，并初始化为 0 */
    int result;  /* 定义变量用于存储系统调用的返回值 */

    result = whoami(name, MAX_NAME_LEN + 1);  /* 调用 whoami 系统调用，获取存储的名字 */

    if (result == -1) {  /* 如果系统调用返回 -1，表示出错 */
        perror("whoami");  /* 打印错误信息 */
        return 1;  /* 返回 1 表示程序执行失败 */
    }

    printf("%s\n", name);  /* 打印获取的名字 */
    return 0;  /* 返回 0 表示程序执行成功 */
}
