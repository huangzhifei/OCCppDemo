//
// OCCppObject.mm
// OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

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
