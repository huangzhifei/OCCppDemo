//
//  CppObject.hpp
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

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

#endif /* CppObject_hpp */
