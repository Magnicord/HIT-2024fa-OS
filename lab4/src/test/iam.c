#define __LIBRARY__  /* 启用内嵌的系统调用定义 */

#include <errno.h>   /* 用于处理错误码 */
#include <stdio.h>   /* 用于标准输入输出 */
#include <unistd.h>  /* 用于系统调用接口 */

_syscall1(int, iam, const char *, name);  /* 定义 iam 系统调用 */

int main(int argc, char *argv[]) {
    int result;  /* 定义变量用于存储系统调用的返回值 */

    if (argc != 2) {  /* 检查命令行参数的数量是否正确 */
        fprintf(stderr, "Usage: %s <name>\n", argv[0]);  /* 打印使用方法 */
        return 1;  /* 返回 1 表示程序执行失败 */
    }

    result = iam(argv[1]);  /* 调用 iam 系统调用，将名字存储到内核中 */
    if (result == -1) {  /* 如果系统调用返回 -1，表示出错 */
        perror("iam");  /* 打印错误信息 */
        return 1;  /* 返回 1 表示程序执行失败 */
    }

    return 0;  /* 返回 0 表示程序执行成功 */
}
