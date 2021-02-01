//
//  CppObject.cpp
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

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
