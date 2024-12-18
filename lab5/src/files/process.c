#include <stdio.h>
#include <stdlib.h>
#include <sys/times.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define HZ 100      /* 时钟频率 */
#define NUM_CHILD 5 /* 子进程数量 */

void cpuio_bound(int last, int cpu_time, int io_time);

int main(int argc, char* argv[]) {
    pid_t pid[NUM_CHILD]; /* 子进程 PID */
    int i;                /* 第 i 个子进程 */

    printf("父进程 PID: %d\n", getpid());

    /* 创建 NUM_CHILD (i.e. 5) 个子进程 */
    for (i = 0; i < NUM_CHILD; i++) {
        pid[i] = fork();  /* 创建子进程 */
        if (pid[i] < 0) { /* 创建失败 */
            perror("Fork 失败");
            exit(1);
        }
        if (pid[i] == 0) {    /* 子进程  */
            if (i % 2 == 0) { /* 偶数进程为 CPU 密集型 */
                printf("CPU 密集型进程 %d 启动 (PID=%d)\n", i, getpid());
                cpuio_bound(10, 1, 0); /* CPU 密集型: 10 秒纯计算 */
            } else {                   /* 奇数进程为 I/O 密集型 */
                printf("I/O 密集型进程 %d 启动 (PID=%d)\n", i, getpid());
                cpuio_bound(10, 1, 9); /* I/O 密集型: CPU:IO = 1:9 */
            }
            exit(0); /* 子进程结束 */
        }
    }

    /* 父进程等待所有子进程结束 */
    for (i = 0; i < NUM_CHILD; i++) {
        wait(NULL);
        printf("子进程 %d (PID=%d) 已结束\n", i, pid[i]);
    }

    printf("所有子进程已结束\n");
    return 0;
}

/**
 * @brief 模拟 CPU 和 I/O 操作
 *
 * @param last 函数实际占用 CPU 和 I/O 的总时间，不含位于就绪队列中的时间，>=0
 * @param cpu_time 一次连续占用 CPU 的时间，>=0
 * @param io_time 一次 I/O 操作消耗的时间，>=0
 */
void cpuio_bound(int last, int cpu_time, int io_time) {
    struct tms start_time, current_time; /* 进程时间 */
    clock_t utime, stime;                /* 用户态和系统态时间 */
    int sleep_time;                      /* sleep 模拟 I/O 操作的时间 */

    while (last > 0) {
        /* CPU 计算阶段 */
        times(&start_time); /* 记录开始时间 */
        /* 仅 tms_utime 代表实际的 CPU 时间 */
        do {
            times(&current_time); /* 获取当前时间 */
            utime = current_time.tms_utime -
                    start_time.tms_utime; /* 计算消耗的用户态时间 */
            stime = current_time.tms_stime -
                    start_time.tms_stime; /* 计算消耗的系统态时间 */
        } while (((utime + stime) / HZ) <
                 cpu_time); /* 循环直到 CPU 时间达到指定秒数 */
        last -= cpu_time;

        if (last <= 0) {
            break;
        }

        /* I/O 操作阶段 */
        /* 使用 sleep(1) 模拟 1 秒的 I/O 操作 */
        sleep_time = 0;
        while (sleep_time < io_time) {
            sleep(1);
            sleep_time++;
        }
        last -= sleep_time;
    }
}
