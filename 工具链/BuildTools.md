# Build Tools

## 常见的构建工具

-   cmake
-   Ninja
-   Bazel
-   GNU Autotools
-   build2
-   xmake

辅助工具:

-   [pkg-config](https://stackoverflow.com/questions/28533059/how-to-use-pkg-config-in-make)
-   bear/compiledb/compiledb-go: 为 ide 生成 `compile_commands.json`。[bear 不能跳过编译](https://github.com/rizsotto/Bear/issues/404)。

## 检查代码

-   CppCheck: 静态检查代码。See [cmake example](https://github.com/ttroy50/cmake-examples/tree/master/04-static-analysis/cppcheck)
-   Valgrind: 如果是运行检查则用得有点卡。
