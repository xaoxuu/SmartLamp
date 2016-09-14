//
//  SceneCollectionView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "SceneCollectionView.h"
#import "SceneCollectionViewCell.h"
// macro
#define NIB_SCENE @"SceneCollectionViewCell"

@interface SceneCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// collection view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// scene list
@property (strong, nonatomic) NSMutableArray<ATProfiles *> *sceneList;

// selected row
@property (assign, nonatomic) NSUInteger selectedRow;

// page control
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation SceneCollectionView


- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupCollectionView];
    [self setupPageControl];
}


// setup collection view
- (void)setupCollectionView{
    // init and add to superview
    
    self.collectionView.backgroundColor = atColor.theme.light;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // style
//    [self.collectionView registerNib:[UINib nibWithNibName:NIB_SCENE bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NIB_SCENE];
    
}

// setup page control
- (void)setupPageControl{
    // init and add to superview
    self.pageControl = [[UIPageControl alloc] init];
    [self addSubview:self.pageControl];
    // style
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = self.sceneList.count;
    self.pageControl.currentPage = 0;
    self.pageControl.width = self.width;
    self.pageControl.height = sMargin;
    self.pageControl.top = self.collectionView.top + sMargin;
    self.pageControl.centerX = self.centerX;
}

#pragma mark lazy load

// sceneList
- (NSMutableArray<ATProfiles *> *)sceneList{
    if (!_sceneList) {
        _sceneList = [ATFileManager readProfilesList];
    }
    return _sceneList;
}




#pragma mark - collection view data source


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sceneList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    
    SceneCollectionViewCell *cell = [SceneCollectionViewCell reusableCellWithCollectionView:collectionView forIndexPath:indexPath];
    // do something
    cell.model = self.sceneList[indexPath.row];
    
    __weak ATProfiles *model = cell.model;
    cell.deleteAction = ^(UIButton *sender){
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self.sceneList indexOfObject:model] inSection:indexPath.section];
        // NSMutableArray remove object at index
        [self.sceneList removeObject:model];
        // save cache
        [ATFileManager saveProfilesList:self.sceneList];
        // view delete rows at index path
        
        [collectionView deleteItemsAtIndexPaths:@[index]];
        [collectionView reloadData];
        self.pageControl.numberOfPages--;
    };
    
    if (indexPath.row == self.selectedRow) {
        cell.selected = YES;
    } else{
        cell.selected = NO;
    }
    // return cell
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenW, 455);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    
    atCentral.letSmartLampApplyProfiles(self.sceneList[self.selectedRow]);
    
    [self reloadData];
    
}

- (void)addItem {
    // save scene
    ATProfiles *aProfiles = [ATProfiles defaultProfiles];
    [self.sceneList addObject:aProfiles];
    [ATFileManager saveProfilesList:self.sceneList];
    // update page
    self.pageControl.numberOfPages++;
    self.pageControl.currentPage = self.sceneList.count-1;
    // reload data
    [self.collectionView reloadData];
    [self at_delay:0.1 performInMainQueue:^(id  _Nonnull obj) {
        [self.collectionView scrollToRight];
    }];
    
}

- (void)reloadData {
	[self.collectionView reloadData];
}

- (void)saveData {
	[ATFileManager saveProfilesList:self.sceneList];
}



#pragma mark - scroll view delegate

// did end decelerating (end scroll)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x/kScreenW;
    self.pageControl.currentPage = index;
}


@end
