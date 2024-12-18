# HIT 2024 Fall Operation System

哈尔滨工业大学 2024 秋操作系统实验。实验手册官网为 [操作系统设计与实现 — Guojunos 1.0.0 文档](https://os.guojunhit.cn/)。本学期课程一共需要完成 5 个实验，即: lab1-lab5

> [!note]
> **本项目仅供参考，请勿抄袭！**

## 项目目录

- `common`: 包含 `linux0.00` 与 `linux0.11` 相关源码以及初始化脚本，实验过程中，需要根据自身实验环境稍作修改。此目录通过实验手册中的官方仓库合并得到，合并命令在后文给出
- `labN`: 包含第 N 个实验的相关源码以及实验报告

`common` 目录合并命令如下：

```bash
# 当前位于此仓库根目录
git subtree add --prefix=common/linux000 https://gitee.com/guojunos/Linux000.git master
git subtree add --prefix=common/linux011 https://gitee.com/guojunos/oslab2020.git master
```

`.gitignore` 文件中排除了 `*.img` 文件，该文件正常位于 `/labN/src/hdc-0.11.img` 与 `/common/linux011/hdc-0.11.img`。由于文件过大，因此将其忽略

## 实验环境

对于 lab1-lab4，实验环境如下:

- 编程语言: C, Assembly
- 宿主机操作系统: Windows 11 23H2
- 虚拟机工具: VMware Workstation Pro 17.5.0
- 虚拟机操作系统: Ubuntu 24.04.1 amd64 Desktop LiveDVD
- Linux 虚拟机软件: Bochs 2.8

虽然课程建议使用 Ubuntu 22.04 与 Bochs 2.7，但笔者实测最新版本的 Ubuntu 与 Bochs 可以使用。[Lab 1 Report](./lab1/README.md) 包含了详尽的 Ubuntu 与 Bochs 配置过程。

对于 lab5，实验环境有部分改动:

- 虚拟机操作系统: Ubuntu 22.04.5 amd64 Desktop LiveDVD
- Linux 虚拟机软件: Bochs 2.4

实验环境可采用老师打包的 VMWare 相关文件，可直接安装。具体改动的原因见 [5. 进程运行轨迹的跟踪与统计 — Guojunos 1.0.0 文档](https://os.guojunhit.cn/linux011/lab03.html):

> [!note]
> 实验 5 打印不对的，原因是模拟器版本高，会导致缓冲那里读写有问题
>
> 第一种是给出分析原因
>
> 第二种做法是降低模拟器版本，之前有同学降到 `bochs 2.4.*` 版本，缓冲的问题就没有了
>
> 实验的目的是大家要学会分析问题，能解决更好，如果能看到在高版本下，把缓冲这个问题分析透彻并解决掉，比直接给出一个正确答案要学到的多得多
>
> 以上两种做法在报告中都算正确

## 实验提交

不同实验老师的要求有所不同，一般而言：

- lab1-lab2: 仅需提交实验报告 (`.md` & `.pdf`)
- lab3-lab5: 实验报告与 `Image` 镜像文件

本仓库 lab3-lab5 的 `Image` 位于 `/labN/src/linux-0.11/Image`

每个实验均需在 1 周内完成提交。对于 lab1-lab4，实验难度中等偏低。只有 lab5 需要花费一定时间。但由于 lab1 需要从 0 配置实验环境，lab3 需要配置 linux 0.11 环境，对于不熟悉 VMWare 与 Linux 的同学，需要留出足够的时间
