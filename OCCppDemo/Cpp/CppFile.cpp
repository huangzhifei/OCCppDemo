//
//  CppFile.cpp
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#include "CppFile.h"


CppFile::CppFile() {
    
}

CppFile::CppFile(string *name) {
    this->name = name;
    cout << __FUNCTION__ << ": "<< *(this->name) << endl;
}

CppFile::CppFile(void *ocObj, OCInterfaceCFundation interFaceFunc) {
    mOCObj = ocObj;
    mInterFaceFunc = interFaceFunc;
}

void CppFile::doSomethingLog(string *log) {
    cout << __FUNCTION__ << ": " << *log << endl;
}

void CppFile::doOCSomething() {
    cout << __FUNCTION__ << ": " << "there is C++" << endl;
    
    mInterFaceFunc(mOCObj, NULL);
}

void CppFile::exampleMethod(string &str) {
    cout << __FUNCTION__ << ": " << str << endl;
}

CppFile::~CppFile() {
    
}
