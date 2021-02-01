//
//  ViewController.mm
//  OCCppDemo
//
//  Created by 黄志飞 on 2021/2/1.
//

#import "ViewController.h"
#import "OCFile.h"
#import "OCFileTest1.h"
#import "NextViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    self.title = @"Home";
    
    OCFile *ocFile = [[OCFile alloc] init];
    [ocFile doSomethingWithOCString:@"HelloCppDemo"];
    
    OCFileTest1 *ocFileTest = [[OCFileTest1 alloc] init];
    [ocFileTest doSomeTest:@"Objective C++"];
    
    [self configSubView];
}

- (void)configSubView {
    [self.view addSubview:self.btn];
    
    [self.btn setFrame:CGRectMake(100, 200, 100, 45)];
    [self.btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickBtn:(id)sender {
    NextViewController *nextVC = [[NextViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn setTitle:@"下一页" forState:UIControlStateNormal];
    }
    return _btn;
}

@end
