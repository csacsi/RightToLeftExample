//
//  ViewController.m
//  arabic
//
//  Created by Csaba Toth on 2017. 09. 14..
//  Copyright © 2017. Skyscanner. All rights reserved.
//

#import "ViewController.h"
#import "SampleCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDropDelegate, UICollectionViewDragDelegate, UIDragInteractionDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_items;
    
    UIView *cell;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(100, 50)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _items = [@[] mutableCopy];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor cyanColor]];
    [_collectionView registerClass:[SampleCollectionViewCell class] forCellWithReuseIdentifier:@"class"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.dropDelegate = self;
    _collectionView.dragDelegate = self;
    _collectionView.dragInteractionEnabled = YES;
    [self.view addSubview:_collectionView];
    
    cell = [UIView new];
    [cell setBackgroundColor:[UIColor greenColor]];
    
    UIDragInteraction *interaction = [[UIDragInteraction alloc] initWithDelegate:self];
    interaction.enabled = YES;
    [cell addInteraction:interaction];
    [cell setUserInteractionEnabled:YES];
    [self.view addSubview:cell];

    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@80);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SampleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"class" forIndexPath:indexPath];
    [cell setTitle:_items[indexPath.item]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView
                            dropSessionDidUpdate:(id<UIDropSession>)session
                        withDestinationIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (session.localDragSession.localContext == _collectionView)
    {
        return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove
                                                                    intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }

    return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy
                                                                    intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
}

-(void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session
{
    session.localContext = collectionView;
}

- (void)collectionView:(nonnull UICollectionView *)collectionView performDropWithCoordinator:(nonnull id<UICollectionViewDropCoordinator>)coordinator {
    if (coordinator.proposal.operation == UIDropOperationCopy)
    {
        [self collectionView:collectionView performCopyDropWithCoordinator:coordinator];
    }
    else if (coordinator.proposal.operation == UIDropOperationMove)
    {
        [self collectionView:collectionView performMoveDropWithCoordinator:coordinator];
    }

}

- (void)collectionView:(UICollectionView *)collectionView performCopyDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray new];
    NSMutableArray<NSString *> *viewModels = [NSMutableArray new];
    NSUInteger loc = _items.count;
    
    if (coordinator.destinationIndexPath != nil)
    {
        loc = coordinator.destinationIndexPath.item;
    }
    
    for (NSUInteger i = 0; i < coordinator.items.count; i++)
    {
        id object = coordinator.items[i].dragItem.localObject;
        
        [viewModels addObject:object];
        [indexPaths addObject:[NSIndexPath indexPathForItem:loc + i inSection:0]];
    }
    
    [collectionView performBatchUpdates:^{
        NSRange range = NSMakeRange(loc, indexPaths.count);
        [_items insertObjects:viewModels atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];

        [collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {}];
}

- (void)collectionView:(UICollectionView *)collectionView performMoveDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator
{
    id<UICollectionViewDropItem> dropItem = coordinator.items.firstObject;
        [collectionView performBatchUpdates:^{
            [_items exchangeObjectAtIndex:dropItem.sourceIndexPath.item withObjectAtIndex:coordinator.destinationIndexPath.item];
            [collectionView moveItemAtIndexPath:dropItem.sourceIndexPath toIndexPath:coordinator.destinationIndexPath];
        } completion:^(BOOL finished) {}];
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath
{
    return @[[self dragItemForIndexPath:indexPath]];
}

- (UIDragItem *)dragItemForIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = _items[indexPath.item];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:string];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    item.localObject  = string;
    
    return item;
}

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session
{
    return YES;
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session
{
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationMove];
}

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session
{
    NSString * string = @"bird";
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:string];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    item.localObject = string;
    
    return @[item];
}
@end

