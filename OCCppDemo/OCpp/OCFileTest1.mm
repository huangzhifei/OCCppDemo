//
// OCFileTest1.mm
// OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import "OCFileTest1.h"

@interface OCFileTest1 ()

@end

@implementation OCFileTest1

- (void)doSomeTest:(NSString *)log {
    NSLog(@"OCFileTest1: %@", log);
    
    string cpp_str([log UTF8String], [log lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    if (mCppFile == NULL) {
        mCppFile = new CppFile();
    }
    mCppFile->exampleMethod(cpp_str);
    
    string *cpp_str1 = new string("OC++");
    mCppFile->doSomethingLog(cpp_str1);
    
}

@end
