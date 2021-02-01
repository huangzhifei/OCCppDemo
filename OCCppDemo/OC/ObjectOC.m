//
// ObjectOC.mm
// OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import "ObjectOC.h"

void OCObjectInterfaceDoWith(void *caller, void *parameter) {
    [(__bridge id)caller doXXX:parameter];
}

@implementation ObjectOC

- (instancetype)init {
    if (self = [super init]) {
        _caller = OCObjectInterfaceDoWith;
    }
    return self;
}

- (void)doXXX:(void *)parameter {
    NSLog(@"this is OC log: %@", parameter);
}

@end
