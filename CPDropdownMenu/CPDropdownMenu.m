//
//  CPDropdownMenu.m
//  CPDropdownMenu
//
//  Created by Nagasawa Hiroki on 2014/05/23.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import "CPDropdownMenu.h"

#pragma mark - CPDropdownMenuItemButton

@implementation CPDropdownMenuItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    UIImage *image = [UIImage imageNamed:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 30, 30)];
    self.iconView = imageView;
    [self addSubview:self.iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.titleLabel = label;
    [self addSubview:self.titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    self.iconView.image = icon;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _backgroundColor = backgroundColor;
}

- (void)setHighlightBackgroundColor:(UIColor *)highlightBackgroundColor
{
    _highlightBackgroundColor = highlightBackgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setBackgroundColor:highlighted ? _highlightBackgroundColor : _backgroundColor];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.buttonTapHandlerBlock) {
        self.buttonTapHandlerBlock();
    }
}

- (void)layoutSubviews
{   
    NSInteger height = self.frame.size.height;
    
    [self.iconView setFrame:CGRectMake(0, 0, height/4, height/4)];
    self.iconView.contentMode = UIViewContentModeCenter;
    self.iconView.center = self.center;
    CGRect iconImageViewFrame = self.iconView.frame;
    iconImageViewFrame.origin.y = height/4;
    self.iconView.frame = iconImageViewFrame;

    self.titleLabel.center = self.center;
    CGRect labelframe = self.titleLabel.frame;
    labelframe.origin.y = height/4 + 30;
    self.titleLabel.frame = labelframe;
}

@end

#pragma mark - CPDropdownMenuCell

@interface CPDropdownMenuCell : UICollectionViewCell
- (void)configureCellWithTitle:(NSString *)title icon:(UIImage *)icon handler:(ButtonTapHandlerBlock)handler;
@end

@implementation CPDropdownMenuCell
{
    CPDropdownMenuItemButton *itemButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    itemButton = [[CPDropdownMenuItemButton alloc] initWithFrame:self.bounds];
    itemButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:itemButton];
}

- (void)configureCellWithTitle:(NSString *)title icon:(UIImage *)icon handler:(ButtonTapHandlerBlock)handler
{
    itemButton.title = title;
    itemButton.icon = icon;
    itemButton.buttonTapHandlerBlock = handler;
    itemButton.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:102/255.f alpha:1];
    itemButton.highlightBackgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:102/255.f alpha:1];
}

@end

#pragma mark - CPDropdownMenu

@interface CPDropdownMenu ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, assign) NSInteger maxItemInRowCount;
@end

@implementation CPDropdownMenu {
    NSMutableArray *buttonItems;
    UICollectionViewFlowLayout *flowLayout;
    UICollectionView *menuCollectionView;
}

+ (instancetype)menu
{
    CPDropdownMenu *menu = [[CPDropdownMenu alloc] initWithFrame:CGRectMake(0, 64, 320, 400)];
    menu.backgroundColor = [UIColor clearColor];
    CGRect rect = menu.frame;
    rect.origin.y = -400;
    menu.frame = rect;
    return menu;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 64, 320, 400)];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    self.maxItemInRowCount = 4;
    //self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    buttonItems = [NSMutableArray array];
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;  // セクションとアイテムの間隔
    flowLayout.minimumInteritemSpacing = 0;  // アイテム同士の間隔
    
    menuCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    menuCollectionView.delegate = self;
    menuCollectionView.dataSource = self;
    menuCollectionView.backgroundColor = [UIColor lightGrayColor];
    
    [menuCollectionView registerClass:[CPDropdownMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([CPDropdownMenuCell class])];
    
    [self addSubview:menuCollectionView];
}

- (void)show
{
    CGRect rect = self.frame;

    NSInteger fullSectionCount = (NSInteger) buttonItems.count / self.maxItemInRowCount;
    
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        /**
         *  端数でない場合
         */
        rect = CGRectMake(0, 64, 320, fullSectionCount * 320/self.maxItemInRowCount);
    } else {
        rect = CGRectMake(0, 64, 320, (fullSectionCount + 1) * 320/self.maxItemInRowCount);
    }
    
    flowLayout.itemSize = CGSizeMake(320/self.maxItemInRowCount, 320/self.maxItemInRowCount);
    
    CGRect rectCollectionView;
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        rectCollectionView = CGRectMake(0, 0, 320, fullSectionCount * 320/self.maxItemInRowCount);
    } else {
        rectCollectionView = CGRectMake(0, 0, 320, (fullSectionCount + 1) * 320/self.maxItemInRowCount);
    }
    menuCollectionView.frame = rectCollectionView;

    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide
{
    NSInteger fullSectionCount = (NSInteger) buttonItems.count / self.maxItemInRowCount;
    CGRect rect = self.frame;
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        rect.origin.y = - (fullSectionCount * 320/self.maxItemInRowCount);
    } else {
        rect.origin.y = - (fullSectionCount + 1) * 320/self.maxItemInRowCount;
    }
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {

    }];
}

- (void)addButtonWithTitle:(NSString *)title icon:(UIImage *)icon tapHandler:(ButtonTapHandlerBlock)handler
{
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    title, @"title",
                                    icon, @"icon",
                                    handler, @"handler",nil];
    
    [buttonItems addObject:tempDictionary];
    
    handler();
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        return (NSInteger) buttonItems.count / self.maxItemInRowCount;
    } else {
        return (NSInteger) buttonItems.count / self.maxItemInRowCount + 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger fullSectionCount = buttonItems.count / self.maxItemInRowCount;
    if (section == buttonItems.count / self.maxItemInRowCount) {
        NSInteger restCount = buttonItems.count - (fullSectionCount * self.maxItemInRowCount);
        return restCount;
    }
    
    return self.maxItemInRowCount;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPDropdownMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CPDropdownMenuCell class]) forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor colorWithRed:30/255.f green:31/255.f blue:32/255.f alpha:1];

    NSDictionary *dictionary = buttonItems[indexPath.item];
    [cell configureCellWithTitle:dictionary[@"title"] icon:dictionary[@"icon"] handler:dictionary[@"handler"]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger fullSectionCount = (NSInteger) buttonItems.count / self.maxItemInRowCount;
    
    NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:indexPath.section];

    CGFloat width,height;
    if (numberOfItemsInSection != self.maxItemInRowCount) {
        /**
         *  端数の列
         */
        NSInteger restCount = buttonItems.count - (fullSectionCount * self.maxItemInRowCount);
        width = ceilf(CGRectGetWidth(self.bounds)/restCount);
        height = ceilf(CGRectGetWidth(self.bounds)/self.maxItemInRowCount);
    } else {
        height = width = ceilf(CGRectGetWidth(self.bounds)/self.maxItemInRowCount);
    }

    CGSize cellSize = CGSizeMake(width,height);
    return cellSize;
}

@end
