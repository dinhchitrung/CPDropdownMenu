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
    UIImage *image = [UIImage imageNamed:@"icon-briefcasetwo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(24, 5, 16, 16)];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,30, 50, 15)];
    label.text = @"item";
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
    itemButton = [[CPDropdownMenuItemButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
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
}

+ (instancetype)menu
{
    CPDropdownMenu *menu = [[CPDropdownMenu alloc] initWithFrame:CGRectMake(0, 64, 320, 300)];
    menu.backgroundColor = [UIColor blueColor];
    CGRect rect = menu.frame;
    rect.origin.y = -300;
    menu.frame = rect;
    return menu;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 64, 320, 300)];
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
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(64, 64);
    flowLayout.minimumLineSpacing = 0;  // セクションとアイテムの間隔
    flowLayout.minimumInteritemSpacing = 0;  // アイテム同士の間隔
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [collectionView registerClass:[CPDropdownMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([CPDropdownMenuCell class])];
    
    [self addSubview:collectionView];
}

- (void)show
{
    CGRect rect = self.frame;
    rect.origin.y = 64;
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        self.frame = rect;
    } completion:^(BOOL finished){
        
    }];
}

- (void)hide
{
    CGRect rect = self.frame;
    rect.origin.y = -300;
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        self.frame = rect;
    } completion:^(BOOL finished){
        
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
    if (indexPath.section == self.maxItemInRowCount - 1) {
        NSInteger restCount = buttonItems.count - ((buttonItems.count / self.maxItemInRowCount) * self.maxItemInRowCount);
        CGFloat fullWidth = CGRectGetWidth(self.bounds)/restCount;
        CGFloat length = CGRectGetWidth(self.bounds)/self.maxItemInRowCount;
        return CGSizeMake(fullWidth, length);
    }

    CGFloat length = CGRectGetWidth(self.bounds)/self.maxItemInRowCount;
    return CGSizeMake(length, length);
}

@end
