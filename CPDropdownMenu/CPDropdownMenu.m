//
//  CPDropdownMenu.m
//  CPDropdownMenu
//
//  Created by Nagasawa Hiroki on 2014/05/23.
//  Copyright (c) 2014年 Nagasawa Hiroki. All rights reserved.
//

#import "CPDropdownMenu.h"

#pragma mark - CPDropdownMenuItemButton

@implementation CPDropdownMenuItemButton {
    UIImageView *imageView
    
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
    UImage *image = [UIImage imageNamed:@"icon-briefcasetwo"];
    imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(24, 5, 16, 16)];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,30, 50, 15)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
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

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.buttonTapHandlerBlock) {
        self.buttonTapHandlerBlock();
    }
}

- (void)layoutSubviews
{
    
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
@end

@implementation CPDropdownMenu {
    NSMutableArray *buttonItems;
    UICollectionViewFlowLayout *flowLayout;
    UICollectionView *_collectionView;
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
    buttonItems = [NSMutableArray array];
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(64, 64);
    flowLayout.minimumLineSpacing = 0;  // セクションとアイテムの間隔
    flowLayout.minimumInteritemSpacing = 0;  // アイテム同士の間隔
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [_collectionView registerClass:[CPDropdownMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([CPDropdownMenuCell class])];
    
    [self addSubview:_collectionView];
}

- (void)show
{
    CGRect rect = self.frame;
    //rect.origin.y = 64;
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        /**
         *  端数でない場合
         */
        rect = CGRectMake(0, 64, 320, ((NSInteger) buttonItems.count / self.maxItemInRowCount) * 320/self.maxItemInRowCount);
    } else {
        rect = CGRectMake(0, 64, 320, ((NSInteger) buttonItems.count / self.maxItemInRowCount + 1) * 320/self.maxItemInRowCount);
    }
    
    flowLayout.itemSize = CGSizeMake(320/self.maxItemInRowCount, 320/self.maxItemInRowCount);
    flowLayout.minimumLineSpacing = 0;  // セクションとアイテムの間隔
    flowLayout.minimumInteritemSpacing = 0;  // アイテム同士の間隔
    
    CGRect rectCollectionView;
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        rectCollectionView = CGRectMake(0, 0, 320, ((NSInteger) buttonItems.count / self.maxItemInRowCount) * 320/self.maxItemInRowCount);
    } else {
        rectCollectionView = CGRectMake(0, 0, 320, ((NSInteger) buttonItems.count / self.maxItemInRowCount + 1) * 320/self.maxItemInRowCount);
    }
    //collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    _collectionView.frame = rectCollectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    [_collectionView registerClass:[CPDropdownMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([CPDropdownMenuCell class])];
    [self addSubview:_collectionView];

    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide
{
    CGRect rect = self.frame;
    if (buttonItems.count % self.maxItemInRowCount == 0) {
        rect.origin.y = - ((NSInteger) buttonItems.count / self.maxItemInRowCount) * 320/self.maxItemInRowCount;
    } else {
        rect.origin.y = - ((NSInteger) buttonItems.count / self.maxItemInRowCount + 1) * 320/self.maxItemInRowCount;
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
    if (section == buttonItems.count / self.maxItemInRowCount) {
        NSInteger restCount = buttonItems.count - ((buttonItems.count / self.maxItemInRowCount) * self.maxItemInRowCount);
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
    
    cell.backgroundColor = [UIColor greenColor];
    cell.layer.borderWidth = 0.3f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    for (int i; i < buttonItems.count; i++) {
        [cell configureCellWithTitle:buttonItems[i][@"title"] icon:buttonItems[i][@"image"] handler:buttonItems[i][@"handler"]];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfItemsInSection = [collectionView numberOfItemsInSection:indexPath.section];
    if (numberOfItemsInSection == self.maxItemInRowCount - 1) {
        /**
         *  端数の列
         */
        NSInteger restCount = buttonItems.count - ((buttonItems.count / self.maxItemInRowCount) * self.maxItemInRowCount);
        CGFloat fullWidth = CGRectGetWidth(self.bounds)/restCount;
        CGFloat length = CGRectGetWidth(self.bounds)/self.maxItemInRowCount;
        return CGSizeMake(fullWidth, length);
    }

    CGFloat length = CGRectGetWidth(self.bounds)/self.maxItemInRowCount;
    return CGSizeMake(length, length);
}

@end
