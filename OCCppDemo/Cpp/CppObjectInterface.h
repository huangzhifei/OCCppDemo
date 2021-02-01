//
//  CppObjectInterface.h
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#ifndef CppObjectInterface_h
#define CppObjectInterface_h

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

#endif /* CppObjectInterface_h */
