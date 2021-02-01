# `OC` 与 `C++` 混合编译

在 `iOS` 开发中， `OC` 代码与  `C++` 代码可以完美的融合在一块，何谓完美？即你上一行敲完 `OC ` 的代码如：`[NSArray objectAtIndex:xx]` 下一行就可以直接敲写 `C++` 的代码如：`string cpp_str([log UTF8String], [log lengthOfBytesUsingEncoding:NSUTF8StringEncoding]); ` 他们可以正常编译、`debug `等。

## 一、`ObjectiveC` 与 `C++` 向下兼容 `C`

`OC` 中的对象虽然是 `ARC` 辅助内存管理，但本质上还是一个 `void *`, 同理 `C++` 也是一样 `void *`，`OC` 之所以调用函数叫做发送消息（`sendMsg`），是因为封装了层独有的 `runtime` 机制，利用 `C` 实现的。

## 二、如何混编

混编过程中主要存在三种文件：
1. 纯 `C++` 类:  `.h` 和 `.cpp`，记得导入 `libc++` 库。
2. 混编类：`.h` 和 `.mm`，你需要创建 `OC` 的类 `.h` 和 `.m`，然后将 `.m` 文件改成 `.mm` 文件，这样就是告诉编辑器，这个文件可以进行混合编译，但是要特别注意一下，他们是嵌套的，即：如果某个 `.m` 文件 `A` 类的头文件引用了一个 `OC` 类 `B` 类的.h，但是这个 `OC` 类 `B` 类的 `.h` 引用了一个 `C++` 类 `C` 类的 `.h`，那么 `OC` 类 `A` 和 `B` 都要改成 `.mm` 这种混编的模式，他们是一串的，为了避免这种情况，我们一般都尽量在 `.mm` 文件里面引用 `C++` 的 `.h` 文件，这样就不会出现连锁效应。
3. 纯 `OC` 类：这个就没什么好说的。

## 三、`OC` 环境调用 `C++`

### 1、创建纯 `C++` 类文件 `CppFile.h & CppFile.cpp`

```
CppFile.h
```

```
#ifndef CppFile_h
#define CppFile_h

#include <iostream>
#include <string>
#include <cassert>

using namespace std;

class CppFile {
    
private:
    string *name;
    
public:
    CppFile(string *name);
    CppFile();
    
    void doSomethingLog(string *log);
    
    void exampleMethod(string &str);
};

#endif
```

我们在来看看 `CppFile.cpp` 的实现

```
CppFile.cpp
```

```
#include "CppFile.h"

CppFile::CppFile() {
    
}

CppFile::CppFile(string *name) {
    this->name = name;
    cout << __FUNCTION__ << ": "<< *(this->name) << endl;
}

void CppFile::doSomethingLog(string *log) {
    cout << __FUNCTION__ << ": " << *log << endl;
    
}

void CppFile::exampleMethod(string &str) {
    cout << __FUNCTION__ << ": " << str << endl;
}
```

### 2、创建混编文件 `OCFile.h & OCFile.m`，然后 `OCFile.m` 文件后缀修改为 `.mm`

```
OCFile.h
```

这里就是一个正常的 `OC` 的头文件类，他里面只有 `OC` 相关的内容
```

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCFile : NSObject

- (void)doSomethingWithOCString:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

```

主要关键点在 `.mm` 这个文件里面。

```
OCFile.mm // 需要.mm才能混合编译
```

```
#import "OCFile.h"
#import "CppFile.h" // import 一个C++的头文件

@interface OCFile() {
    CppFile *mCppFile; // 定义一个C++的对象
}

@end

@implementation OCFile

- (void)doSomethingWithOCString:(NSString *)str {
    NSLog(@"doSomethingWithOCString: %@", str);
    if (mCppFile == NULL) {
        string *tstring = new string([str UTF8String]);
        mCppFile = new CppFile(tstring);
    }
}

@end

```

我们在来看看使用 `OCFile` 的地方，由于 `OCFile.h` 里面没有 `C++` 相关的东西，所以调用 `OCFile` 的地方只需要是一个正常的 `OC` 类就行也就是 `.m` 文件就行

```
ViewController.m 
```

```
#import "ViewController.h"
#import "OCFile.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    OCFile *ocFile = [[OCFile alloc] init];
    [ocFile doSomethingWithOCString:@"HelloCppDemo"];
}

@end
```

## 四、`C++` 环境调用 `OC`

`C++ => OC` 就相对麻烦一点，网上大多是利用 `C` 函数做桥，将 `OC` 对象转化为 `void *` 类型的指针传入，这种方式太复杂，也不够灵活，这里就不讲了，他的流程如下：

```
C++ 类调用 C 的方法，C方法里面写死调用OC的具体默个方法。这种方法不讲，自行上网搜索
```

**另外一种利用.mm，把C++的实现在混编文件.mm中实现，.h只用来做接口**

即 `.mm` 中调用 `C++` 类 `A`，`C++` 类 `A` 调用 `C++` 类 `B`，但是类 `B` 是在`.mm` 文件类 `C` 中实现，这样唯一的坏处理是有一个 `C++` 类 `B` 和 `.mm` 类 `C` 混合在一起了。但是通过 `#pragma` 来区分还是很明显的。

我们来看下面的例子：

### 1、先定义一个 接口类的 `C++` 类，他没有对应的 `.cpp` 文件 => 这个就是 `C++` 类 `B`

```
CppObjectInterface.h // 
```

```
// 这个类没有对应的.cpp实现，他的实现在另一个.mm中

class CppObjectImpl {
    
public:
    CppObjectImpl();
    ~CppObjectImpl();

    void init();
    int doSomethingWith(void *param);
    void logSomething(char *cStr);

  private:
    void *self;
    
};
```

### 2、定义一个混编的类，`.mm` 里面实现上面定义的 `C++` 的方法 => 这个就是 `OC` 类 `C`

```
OCCppObject.mm
```

```
#import "OCCppObject.h"
#import "CppObjectInterface.h"

typedef void (^RetainSelfBlock)(void);

@interface OCCppObject ()

@property (nonatomic, copy) RetainSelfBlock retainBlock; //通过这个block持有C++对象，造成循环引用，避免被释放

@end

@implementation OCCppObject

#pragma mark - OC 的方法

- (int)startDoSomething:(void *)param {
    return 10;
}

- (void)startLogMessage:(char *)log {
    NSLog(@"【OC】%s 完成, %s", __FUNCTION__, log);
}

- (void)breakRetain {
    NSLog(@"【OC】%s", __FUNCTION__);
    self.retainBlock = nil;
}

- (void)dealloc {
    NSLog(@"【OC】%s", __FUNCTION__);
}

#pragma mark - C++ 的方法

CppObjectImpl::CppObjectImpl() : self(NULL) {
    NSLog(@"【C++】%s 完成, self = %p",__FUNCTION__, self);
}

CppObjectImpl::~CppObjectImpl() {
    NSLog(@"【C++】%s 完成, self = %p",__FUNCTION__, self);
    [(__bridge id)self breakRetain];
}

void CppObjectImpl::init() {
    OCCppObject *obj = [[OCCppObject alloc] init];
    obj.retainBlock = ^{
        [obj class]; // 让其循环引用，保持对象不释放
    };
    self = (__bridge void *)obj;
    NSLog(@"【C++】%s 完成, self = %p",__FUNCTION__, self);
}

int CppObjectImpl::doSomethingWith(void *param) {
    NSLog(@"【C++】%s 完成, self = %p", __FUNCTION__, self);
    return [(__bridge id)self startDoSomething:param];
}

void CppObjectImpl::logSomething(char *cStr) {
    NSLog(@"【C++】%s 完成, self = %p", __FUNCTION__, self);
    
    [(__bridge id)self startLogMessage:cStr];
}

@end

```

### 3、现在就是我们的 C++ 类 A

```
CppObject.hpp
```

```
#ifndef CppObject_hpp
#define CppObject_hpp

#include <iostream>
#include <string>
#include <cassert>
#include "OCObjectInterface.h"

using namespace std;

class CppObjectImpl;

class CppObject {
    
public:
    CppObject();
    ~CppObject();
    
    void init();
    void doSomethingWithMyClass();
    
private:
    CppObjectImpl *mImpl;
};

#endif
```

他的 .cpp 里面的实现，调用了 C++ 类 B，C++ 类 B 和 OC 类 C 在混编中，所以能轻松的调用 OC 类 C，这样就实现了 C++ => OC 的调用

```
CppObject.cpp
```

```
#include "CppObject.hpp"
#include "CppObjectInterface.h"

CppObject::CppObject(): mImpl(NULL) {
    
}

CppObject::~CppObject() {
    cout << "【C++】" << __FUNCTION__ << " 开始析构 CppObjectImpl " << endl;
    if (mImpl) {
        delete mImpl;
        mImpl = NULL;
    }
}

void CppObject::init() {
    mImpl = new CppObjectImpl();
    mImpl->init();
}

void CppObject::doSomethingWithMyClass() {
    int result = mImpl->doSomethingWith(NULL);
    cout << "【C++】" << __FUNCTION__ << " result: " << result << endl;
    char str[] = "Hello C++ => OC";
    mImpl->logSomething(str);
}

```

### 4、最后就是触发这次调用的例子

```
NextViewController.mm
```

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"Next";
    
    CppObject *obj = new CppObject();
    obj->init();
    obj->doSomethingWithMyClass();
    NSLog(@"%s, 开始析构C++对象CppObject: %p", __FUNCTION__, obj);
    delete obj;
}

```

### 5、最后打印

```

【C++】CppObjectImpl 完成, self = 0x0
【C++】init 完成, self = 0x600003644610
【C++】doSomethingWith 完成, self = 0x600003644610
【C++】doSomethingWithMyClass result: 10
【C++】logSomething 完成, self = 0x600003644610
【OC】-[OCCppObject startLogMessage:] 完成, Hello C++ => OC
【OC】-[NextViewController viewDidLoad], 开始析构C++对象CppObject: 0x60000365adb0
【C++】~CppObject 开始析构 CppObjectImpl 
【C++】~CppObjectImpl 完成, self = 0x600003644610
【OC】-[OCCppObject breakRetain]
【OC】-[OCCppObject dealloc]

```

## 五、`Objective-C++` 之混编注意事项

**1. 只要将 `.m` 文件重命名为 `.mm` 文件，就是告诉编译器，这个文件可以进行混编**

**2. `header` 文件没有后缀名变化，即没有 `.hh` 文件，我们要尽量保持头文件的整洁，将混编代码从头文件移入到 `.mm` 文件中，保证头文件要么是纯正 `C++`，要么是纯正 `OC`（可以含有`C` ）**

**3. `OC` 和 `C++` 都是完全兼容 `C` 的，所以有时候也可以使用 `void*` 指针来当做桥梁，来回在两个环境间传递**

**4. `OC` 与 `C++` 类尽量分开，他们是两种语言，防止混合使用**

## 六、`Objective-C++` 之内存管理

**`OC` 是有 `ARC` 这样的引用计数管理内存的，但是 `C++` 是没有的，他需要我们手动管理内存！**

首先我们来了解几个 `OC` 的关键字：

1.` __bridge`：`ARC` 下 `OC` 与 `Core Foundation` 对象之间的桥梁，转化时 **“只涉及对象类型”** 不涉及对象所有权的转化。
2. `__bridge_retained`：将内存所有权同时归原对象和变换后的对象持有，**“并对变换后的对象做一次 `retain`”**。
3. `__bridge_transfer`：将内存所有权彻底移交变换后的对象持有，**“`retain` 变换后的对象，`release` 变换前的对象”**。

### 1、在 `.mm` 文件中，`OC` 环境下在 `init` 和 `dealloc` 中对 `C++` 类进行 `new` 和 `delete` 操作

看下面的例子：

```
OCFile.mm
```
```
- (id)init {
    self = [super init];
    if (self) {
        wrapped = new CppObject();
    }
    return self;
}

- (void)dealloc {
    delete wrapped;
}
```

### 2、在 `.mm` 文件中，`C++` 环境下在构造和析构函数中进行 `init` 和 `release` 操作

看下面的例子：

```
CppFile.cpp
```

```
AntiCppObject::AntiCppObject() {
    AntiOcObject* t =[[AntiOcObject alloc]init];
    sth = new sthStruct;
    sth->oc = t;
}

AntiCppObject::~AntiCppObject() {
    if (sth) {
        [sth->oc release];//arc的话，忽略掉这句话不写
    }
    delete sth;
}
```

`sth`  是一个 `C` 的结构体 `struct`，变量  `oc`  是定义的对象  `sthStruct* sth`

### 3、内存管理总结

一句话：`OC` 自己的用 `ARC` 管理，`C` 或 `C++` 自己管理，`malloc` 的要 `free`，`new` 的要 `delete`


## 七、`OC` 的 `@property` 如何定义 `C++` 对象

不建议通过 `property` 来定义 `C++` 的对象，因为他不能通过 `weak, strong, or retained` 这几个关键字来管理内存，要加只能使用下面的方法：

```

// This property can only be used in Objective-C++ code
#ifdef __cplusplus
@property  MyCPP * myCPP;
#endif

```

但是这样加的他默认是  `(unsafe_unretained, assign, atomic)` ,另外我们还要自己实现 `setter&getter` 方法，在里面做一些内存释放等。

所以最好是直接定义成下面的形式：

```

@interface OcObject : NSObject {
    CppObject* wrapped;
}

```



