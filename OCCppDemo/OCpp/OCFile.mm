//
//  OCFile.mm
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import "OCFile.h"
#import "CppFile.h" // import 一个C++的头文件
#import "ObjectOC.h"

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

- (void)testCCToOC {
    ObjectOC *t = [[ObjectOC alloc] init];
    void *CCObj = (__bridge void*)t;
    
    CppFile *cc = new CppFile(CCObj, t.caller);
    cc->doOCSomething();
}

- (void)dealloc {
    delete mCppFile; // 需要手动管理C++的释放
}

@end
