# Compare C++

## Content

[toc]

## 说明

-   C++ 与其他语言的比较。假设 C++ 不用兼容 C 的语法和历史遗留的问题。

## 为函数添加关键字

现在变量, 类型, 名字空间等都有专门的关键字, 但函数没有。如果为函数添加 function/fn 关键字, 这不仅可以使得语法完整, 而且可以使得语法不容易混淆, 解决"双括号问题"。

双括号问题:

```cpp
class Foo {
public:
  Foo(int i1, int i2) {}
};

int main() {
  int i = 10;
  
  // int 也可以替换为自定义类型
  Foo foo1(int(1), int());    // ok. 因为 `1` 不能是参数名。
  Foo foo2(int(i), int());    // 相当于声明 `Foo foo2(int i, int(*)())` 函数。

  // ## 解决
  Foo foo2{int(i), int()};
  // OR
  //Foo foo2((int(i)), int());    // 双括号
}
```

导入函数或许可以学习 Rust 使用 use (using)。这样可以区分声明和导入。

## C/C++ 为什么要按顺序声明?

现在的新语言可以不按顺序定义也可以正常调用, 但是 C 为什么要按顺序声明:
-   因为 C 的编译器是单遍编译器。历史原因, 之后也无法改了。See [ref](https://www.reddit.com/r/C_Programming/comments/13nz5la/comment/jl1wjly/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)。

还有, 追踪返回类型（auto and decltype）中, 可以省略 auto。for example:

```cpp
// 由于编译器从左到右读入符号，ta, tb 还没有定义，为解决这个问题，引入新语法，追踪返回值类型。
template<typename Ta, typename Tb>
decltype(ta + tb) func(Ta ta, Tb tb) {
  return ta + tb;
}

// 新语法
template<typename Ta, typename Tb>
auto func(Ta ta, Tb tb) -> decltype(ta + tb){       // 由于编译器的历史遗留问题 (从左到右读入符号), 其实可以省略 auto。
  return ta + tb;
}
```

## namespace 导致的缩进问题

为了减少缩进, 现在 namespace 一般这样写:

```cpp
namespace ns {
void foo() {}
void bar() {}
} // ns
```

比较新的语言会使用文件即模块的管理方式。

## 明确资源的拥有权

明确指针对资源的拥有权:
-   指针是不明确资源的拥有权的, 可以是拥有或借用资源。
-   C++ 也是意识到了这一点的重要性。比如: unique_ptr, shared_ptr 和 [gslowner](https://github.com/microsoft/GSL/blob/main/docs/headers.md#gslowner) (和指针没有什么区别, 只是方便用户阅读代码时, 知道该指针拥有资源)

## C++ 更加倾向于帮用户完成"无聊"的事情

Rust 的设计哲学之一是 "Be Explicit", 而 C++ 更多倾向于帮用户完成"无聊"的事情。因为 C++ 设计者觉得人很容易在无聊的事情上出错。

C++ 编译器会帮用户完成以下的"无聊"的事情:

-   自动补全 this (self)

    this 是非静态成员函数的第一个参数。多数语言都要求用户手写, 而 C++ 编译器会自动完成。

    注意, 在模板的继承中, 调用基类的东西时, 要向编译器指明调用基类的东西。See 《Effective C++》条款 43: 学习处理模板化基类内的名称。

    我觉得统一性的优先级更高, 让用户手写 this 会更好 (这样就不会出现"学习处理模板化基类内的名称"的特例)。但是 `this->` 写起来比较麻烦, 使用 `self.` 会方便一点。

-   参数依赖查找: 因为支持重载, 如果函数的实参是一个自定义类型, 那么这个函数很有可能是与实参的类型在同一个名字空间。

    for example:

    ```cpp
    #include <iostream>
    
    namespace MyNamespace {
    struct MyType {};
    
    void myFunction(MyType) {
      std::cout << "MyNamespace::myFunction called!" << std::endl;
    }
    } // namespace MyNamespace
    
    int main() {
      MyNamespace::MyType obj;
      myFunction(obj); // 使用 ADL 查找到 MyNamespace::myFunction
      return 0;
    }
    ```

-   没有 explicit 的构造函数也是一个类型转换

    但是对于只有一个参数的构造函数或类型转换方法, 建议使用 explicit, 除非你是想要一个转换:
    -   因为只有一个参数的类型转换是用户很不容易察觉的, 而多参数的类型转换, 会使用 `{arg1, arg2}`。
    -   为什么只有一个参数的类型转换是用户难以察觉的, 因为它和"正常"的语法没有多大的区别, 区别在于知道类型的区别。比如:
        
        ```cpp
        // ## 只有一个参数的类型转换 (每条语句都有可能发生隐匿转换)
        if (obj1 == obj2) {
          obj1 += obj2
        }
        func(obj1)
        // ...

        // ## 多个参数的类型转换
        if (obj = {arg1, arg2}) {
        }
        func({arg1, arg2})
        ```

    我觉得构造函数应该默认是 `explicit` 的, 如果想要转换再为构造函数添加 `implicit` 即可。猜测是为了兼容 C++11 之前的标准, 而导致这样设计的。

## 支持函数重载 (overload) 和默认值的优缺点

支持函数重载和默认值需要定制一套函数重载的匹配机制, 以及提供自定义类型的转换。这匹配机制会涉及一点参数转换的优先级。详细请看《C++ Primer》的"重载解析的三个步骤"和"参数类型转换"。

还有 function, bind 辅助工具。bind 统一函数格式, function 可以接收多样的函数。比如: 编写回调函数时会比较方便。

但是也会引入了要解决的问题:
-   默认值与函数重写 (override): 《Effective C++》条款 37: 绝不重新定义继承而来的缺省参数值
-   虽说重载和默认值可能造成调用歧义, 但是这种场景几乎不会出现:

    ```cpp
    #include <iostream>

    void func(int a) {
      std::cout << "func1\n";
    }
    void func(int a, int b = 2) {
      std::cout << "func2\n";
    }

    int main() {
      func(1);    // 虽然有调用歧义, 但实际的应用场景中, `func(int, int = 2)` 已经包含了 `func(int)` 的功能。
      return 0;
    }
    ```

有些语言可能没有提供重载的功能, 但是有默认值的功能。比如: 对于 lua 的函数默认值, 如果没有相应的实参, 则形参会初始化为 nil (函数中判断为 nil 时则初始化为默认值)。还有 Rust:

```rust
fn greet(name: Option<&str>) {
    // 设置默认值
    let name = name.unwrap_or("World");
    println!("Hello, {}!", name);
}

fn main() {
    greet(Some("Alice")); // 输出: Hello, Alice!
    greet(None);          // 输出: Hello, World!
}
```

我认为 lua 和 rust 的默认值设计比 C++ 的好, 没有引用新的问题。当然 C++ 也有 Option。See [std::optional](std::optional)。

重载和默认值确定有强大之处, 但是会带来比较高学习成本 (重载函数的匹配机制和参数转换优化级), 以及可能会引入新的问题 (e.g. "绝不重新定义继承而来的缺省参数值")。Rust 之后可能会实现重载的功能。See [ref](https://www.reddit.com/r/rust/comments/11ddclh/comment/ja8zkmf/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)。

## 支持捕获运行时异常的优缺点

异常设计的目的是, 使异常处理代码和正常流程代码分离, 提高代码的可读性。

C++ 现在使用 "zero-cost exception handling (零成本异常处理)"。即不抛出异常的情况下, 其成本和没有异常处理的代码一样, 只是判断返回值是否要抛出异常。如果抛出异常的话, 则成本比较高。它需要 "Unwind Stack (栈展开)", 查找调用栈的相应的异常处理。See [ref](https://blog.the-pans.com/cpp-exception-1/)。

如果发生大量的异常则使得程序的性能下降, 所以一些项目排斥异常处理。当然也有一些应对方法:
-   解决方法类似于 Rust 的 Result。
-   将定义一个 Result 类型, 存放正常结果和 `std::exception_ptr`。
-   当要取出 Result 的正常结果时, 先判断是否有异常。
-   如果有异常则抛出重新异常处理或者终止程序, 否则取得正常的结果。
-   这样可以避免"栈展开"。

如果想检查异常的类型时, 则需要重新抛出异常, 这会带来性能影响, 所以有不用重新抛出异常就可以检查异常的类型的提案。同时编译增加异常的类型信息, 使得 exception_ptr 以类型安全的方式直接访问指向的异常。比如, `try-catch<T>`。还有 `std::exception_ptr::type_info`。。See [Better “Goodput” Performance through C++ Exception Handling](https://www.scylladb.com/2024/05/14/better-goodput-performance-through-c-exception-handling/) and [How to catch an exception_ptr without even try-ing](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1066r1.html)。

总结:
-   支持捕获运行时异常可以实现异常处理代码和正常流程代码分离, 提高代码的可读性。但是有大量的异常时会影响性能, 没有异常时则是零成本的。
-   可以像 Rust 一样使用 Result (and_then, or_else, ...), Option, `?` 和解构语法等工具实现无异常编程。可读性会增加, 但是无法实现正常流程代码和异常处理代码分离。C++ 目前有 [`std::optional`](https://zh.cppreference.com/w/cpp/utility/optional), [`std::expected (Result)`](https://en.cppreference.com/w/cpp/utility/expected)。

## 总结

新的语言语法会更加统一, 且没有历史遗留问题。但是语言的生态需要时间来完善。但是新旧语言的设计思想有共通性。比如: 明确资源拥有权。随着类型推导编译技术的成熟, 以后的语言不必每次都写类型。比如: C++ 的 `auto`, Rust 的 `let`。

对于一门语言的功能是否越多越好, 我的看法是:
-   添加一个新功能, 语言的复杂性可能增加 `1 * n (其他功能)`, 而不是 `1`。比如: "函数重载", "绝不重新定义继承而来的缺省参数值"。它可能之前的功能产生矛盾, 需要进一步解决新出的矛盾, 这也会使用用户的学习成本增加。
-   所以我觉得功能够用就行了。这会导致语言会进一步细分应用领域, 将够用的功能拆分出来, 可以减少学习成本。

C++ 功能很强大, 但是可能有历史遗留问题和兼容 C 的问题, 使得它并没有像新的语言那样语法统一, 简单易学。但是编程语言的设计思想和应用场景是有共通性的, 所以要专注于语言的功能对应的应用场景和其设计思想。而不必在意几乎不存在的应用场景。比如: `++a++` 等。

## Reference

-   《Effective C++》
-   《深入理解C++11：C++11新特性解析与应用》
-   [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/)
