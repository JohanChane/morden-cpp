# Package Manager

新出的语言基本自带包管理工具, 这样确实会很方便。比如, rust 有 cargo。

C++ 并没有相应的包管理工具, 但是有出现了相应的生态:
-   [conan](https://github.com/conan-io/conan)
-   [vcpkg](https://github.com/microsoft/vcpkg)
-   cmake 可以下载库, 但是不方便。可以使用 [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)。

我比较喜欢 conan。

## conan

[build.sh](./build.sh)
