
//
//  ItemsView.m
//  ENT_tranPlat_iOS
//
//  Created by xinpenghe on 15/12/23.
//  Copyright © 2015年 ___ENT___. All rights reserved.
//

#import "ItemsView.h"
#import "MyViewLayout.h"
#import "ItemViewCell.h"

#define ItemWidth 64

@interface ItemsView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

static CGFloat lineSpace;
static CGFloat itemSpace;
static UIEdgeInsets edgeInset;
static NSArray *dataSource;
static NSString *cellId = @"cellId";
static NSString *headerId = @"headerId";
static NSString *footerId = @"footerId";

@implementation ItemsView

+ (ItemsView *)shareWithItems:(NSArray *)items pictures:(NSArray *)pics lineSpacing:(CGFloat)lineSpacing itemSpacing:(CGFloat)itemSpacing edgeInsets:(UIEdgeInsets)inset{
    dataSource = items;
    lineSpace = lineSpacing;
    itemSpace = itemSpacing;
    edgeInset = inset;
    
    ItemsView *itemV = [[ItemsView alloc]init];
    return itemV;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    if (self) {
        MyViewLayout *layout = [[MyViewLayout alloc]init];
        layout.minimumLineSpacing = lineSpace;
        layout.minimumInteritemSpacing = itemSpace;
        layout.sectionInset = edgeInset;
        layout.itemSize = CGSizeMake(ItemWidth, ItemWidth);
        
        NSInteger cols = (NSInteger)(APP_WIDTH-edgeInset.left-edgeInset.right)/(ItemWidth+itemSpace);
        NSInteger rows = (dataSource.count/cols)*cols < dataSource.count ? dataSource.count/cols+1:dataSource.count/cols;
        NSInteger height = rows*(lineSpace+ItemWidth)+edgeInset.top+edgeInset.bottom;
        
        self.height = height;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, height) collectionViewLayout:layout];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[ItemViewCell class] forCellWithReuseIdentifier:cellId];
        
         collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [self addSubview:collectionView];
    }
    
    return self;
}

#pragma mark - UICollectionViewDelegate && UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[ItemViewCell alloc]init];
    }
//    cell.icon.image = dataSource[indexPath.row];
    cell.icon.backgroundColor = [UIColor blackColor];
    cell.l.text = dataSource[indexPath.item];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
//        if (!headerView) {
//            headerView = [[CollectionHeaderView alloc]init];
//        }
//        
//        return headerView;
//    }
//    CollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
//    if (!footerView) {
//        footerView = [[CollectionFooterView alloc]init];
//    }
//    
//    return footerView;
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//    CGSize size = {self.width,headerViewHeight};
//    
//    return size;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    
//    CGSize size = {self.width,footerViewHeight};
//    
//    return size;
//}

@end
