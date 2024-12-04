/* kernel/who.c */
#include <asm/segment.h>  /* 使用 get_fs_byte 和 put_fs_byte */
#include <errno.h>        /* 使用 EINVAL 错误码 */

#define MAX_NAME_LEN 23  /* 最大名称长度为 23 */

static char stored_name[MAX_NAME_LEN + 1] = {0};  /* 用于存储名字的静态数组 */

/**
 * @brief 将字符串参数 `name` 的内容拷贝到内核中保存下来。
 *
 * @param name 要拷贝的字符串，长度不能超过 23 个字符。
 * @return 返回拷贝的字符数。如果 `name` 的字符个数超过了 23，则返回 -1，并置
 * `errno` 为 `EINVAL`。
 */
int sys_iam(const char *name) {
    char ch;
    int len;

    /* 首先检查 name 的长度是否超过 MAX_NAME_LEN */
    for (len = 0; len <= MAX_NAME_LEN; len++) {
        ch = get_fs_byte(name + len);  /* 从用户空间获取字符 */
        if (ch == '\0') {              /* 如果是字符串结束符 */
            break;                     /* 结束循环 */
        }
    }

    if (len > MAX_NAME_LEN) {  /* 如果超过最大长度 */
        return -EINVAL;        /* 返回错误 */
    }

    /* 重新遍历 name 并将其存储到 stored_name 中 */
    for (len = 0; len <= MAX_NAME_LEN; len++) {
        ch = get_fs_byte(name + len);  /* 从用户空间获取字符 */
        stored_name[len] = ch;         /* 将字符存入内核空间 */
        if (ch == '\0') {              /* 如果是字符串结束符 */
            break;                     /* 结束循环 */
        }
    }

    return len;  /* 返回拷贝的字符数 */
}

/**
 * @brief 将内核中由 `iam()` 保存的名字拷贝到 `name` 指向的用户地址空间中。
 *
 * @param name 指向用户地址空间的字符数组，用于存储拷贝的名字。
 * @param size `name` 数组的大小，用于防止越界访问。
 * @return 返回拷贝的字符数。如果 `size` 小于需要的空间，则返回 -1，并置 `errno`
 * 为 `EINVAL`。
 */
int sys_whoami(char *name, unsigned int size) {
    int len = 0;  /* 名字长度 */

    while (stored_name[len] != '\0') {  /* 遍历已存储的名字 */
        len++;                          /* 计算已存储名字的长度 */
    }
    if (size < len + 1) {  /* 如果提供的缓冲区太小 */
        return -EINVAL;    /* 返回错误 */
    }
    for (int i = 0; i <= len; i++) {
        put_fs_byte(stored_name[i], name + i);  /* 将名字拷贝到用户空间 */
    }
    return len;  /* 返回拷贝的字符数 */
}
