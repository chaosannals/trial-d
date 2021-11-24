# jrexp

- jre 目录放 jre8u251 版本，xp 下最高的 jre 版本。
- lib 目录为 jar 包目录
- run 目录为日志目录

## 编译

```bash
# 编译 32 位 x86
dub build -a x86
```

```bash
# 图标
# 在 VC 的命令环境下使用 rc 生成 app.res 文件
rc /v app.rc
```
