//
//  NextViewController.mm
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import "NextViewController.h"
#import "CppObject.hpp"

@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"Next";
    
    CppObject *obj = new CppObject();
    obj->init();
    obj->doSomethingWithMyClass();
    NSLog(@"%s, 开始析构C++对象CppObject: %p", __FUNCTION__, obj);
    delete obj;
}

@end
