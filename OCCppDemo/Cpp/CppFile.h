//
//  CppFile.h
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#ifndef CppFile_h
#define CppFile_h

#include <iostream>
#include <string>
#include <cassert>
#include "OCObjectInterface.h"

using namespace std;

class CppFile {
    
private:
    string *name;
    void *mOCObj;
    OCInterfaceCFundation mInterFaceFunc;
    
public:
    CppFile(void *ocObj, OCInterfaceCFundation interfaceFunc);
    CppFile(string *name);
    CppFile();
    
    ~CppFile();
    
    void doSomethingLog(string *log);
    
    void exampleMethod(string &str);
    
    void doOCSomething();
};

#endif /* CppFile_hpp */
