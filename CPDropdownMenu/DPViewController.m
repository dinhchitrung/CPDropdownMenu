//
//  DPViewController.m
//  CPDropdownMenu
//
//  Created by Nagasawa Hiroki on 2014/05/23.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import "DPViewController.h"

@interface DPViewController ()

@end

@implementation DPViewController {
    BOOL hidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(tapBtn:)];
    self.navigationItem.rightBarButtonItem = btn;
    
    hidden = YES;
    self.dropDownMenu = [CPDropdownMenu menu];
    
    /**
     *  14個のボタンを生成
     */
    for (NSInteger i = 0; i < 14; i++) {
        [self.dropDownMenu addButtonWithTitle:@"写真" icon:[UIImage imageNamed:@"fork"] tapHandler:^{
            NSLog(@"Handle!!!");
        }];
    }
    
    [self.view addSubview:self.dropDownMenu];
}

- (void)tapBtn:(UIBarButtonItem *)btn
{
    if (hidden) {
        [self.dropDownMenu show];
        hidden = NO;
    } else {
        [self.dropDownMenu hide];
        hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
