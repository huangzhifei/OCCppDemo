//
// OCFileTest1.h
// OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import <Foundation/Foundation.h>
#import "CppModuleHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCFileTest1 : NSObject {
    CppFile *mCppFile;
}

- (void)doSomeTest:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
