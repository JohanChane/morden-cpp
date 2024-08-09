# C++ Style

## C++ 没有统一的命名规范和编程风格

现在新出的语言基本有统一的命名规范和编程风格。由于 C++ 没有统一的命名规范和编程风格, 会导致各个模块或库之间的命名混乱, 对 C++ 的推广有一定的影响。但是一个项目必须统一编程风格和命名规范。虽然很多人要求统一, 但是 C++ 之父并没有统一, 只是有一些建议。See [ref](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-naming)。

## 比较著名的命名规则和编程风格

-   [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html)
-   类似 [Java 的命名规则](https://www.oracle.com/java/technologies/javase/codeconventions-namingconventions.html): 用驼峰命名法比较多
-   类似 [Rust 的命名规则](https://doc.rust-lang.org/1.0.0/style/style/naming/README.html): 类型用大驼峰命名法, 变量使用下划线命名法。
-   匈牙利命名法: 用这个命名法的项目基本是很老的项目了。变量带类型是一个不好的做法, 现在已经淘汰。

## 我喜欢的命名规则和编程风格

我比较喜欢 rust 的命名规则。类型用大驼峰, 变量和函数使用下划线命名法。

当然有些东西不直接套用或者并没有交集:
-   比如: rust 的变量和函数是可以同名的, 但是 C++ 却不行:
    -   比如有 `is_dirty` 私有数据成员, 那么判断 `is_dirty` 的方法名是? 方法名还是使用 `is_dirty` 比较直观, 所以可以在数据成员前面加 `m_`, 这样就是 `m_is_dirty`, 方法名可以是 `is_dirty`。我并不喜欢 Google C++ Style Guide 在后面加一个下划线的做法。静态数据成员在前面加 `m_` (有些人喜欢加 `g_`, 我觉得利用 ide 可以区分, 则不需要在代码上作区分)。由于现在很多语言都不省略 self 了, 而 C++ 的 self(this) 是编译器自动完成的, 所以数据成员和方法成员不同名时, 方法的形参和数据成员比较容易区分且形参不用想别的名称。
-   头文件使用 `.h`, 源文件使用 `.cc`:
    -   应该使用统一的后缀, 而不是有 `.h`, `.hpp` 等之类的区分。See [ref](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#nl27-use-a-cpp-suffix-for-code-files-and-h-for-interface-files)
    -   个人使用 `.cc` 是感觉使用 Google 的一些库比较方便。比如: [protobuf生成cpp后缀的文件](https://github.com/protocolbuffers/protobuf/issues/5557)
