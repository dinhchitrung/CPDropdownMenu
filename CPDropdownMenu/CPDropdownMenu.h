//
//  CPDropdownMenu.h
//  CPDropdownMenu
//
//  Created by Nagasawa Hiroki on 2014/05/23.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonTapHandlerBlock)();

@interface CPDropdownMenuItemButton : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) ButtonTapHandlerBlock buttonTapHandlerBlock;
@end

@interface CPDropdownMenu : UIView
@property (nonatomic, assign, readonly) NSInteger maxItemInRowCount;
+ (instancetype)menu;
- (void)show;
- (void)hide;
- (void)addButtonWithTitle:(NSString *)title icon:(UIImage *)icon tapHandler:(ButtonTapHandlerBlock)handler;
@end
