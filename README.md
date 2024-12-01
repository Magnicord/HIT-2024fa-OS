# HIT 2024 Fall Operation System

哈尔滨工业大学 2024 秋操作系统实验

## 项目目录

- `common`: 包含 `linux0.00` 与 `linux0.11` 相关源码以及初始化脚本，实验过程中，需要根据自身实验环境稍作修改。此目录通过实验手册中的官方仓库合并得到，合并命令在后文给出
- `labN`: 包含第 N 个实验的相关源码以及实验报告

`common` 目录合并命令如下：

```bash
# 当前位于此仓库根目录
git subtree add --prefix=common/linux000 https://gitee.com/guojunos/Linux000.git master
git subtree add --prefix=common/linux011 https://gitee.com/guojunos/oslab2020.git master
```
