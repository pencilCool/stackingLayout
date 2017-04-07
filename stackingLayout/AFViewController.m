//
//  ViewController.m
//  stackingLayout
//
//  Created by tangyuhua on 2017/4/7.
//  Copyright © 2017年 tangyuhua. All rights reserved.
//

#import "AFViewController.h"
#import "AFCollectionViewStackedLayout.h"
#import "AFCollectionViewFlowLayout.h"
#import "AFCoverFlowFlowLayout.h"

#import "AFCollectionViewCell.h"
#import "AFCollectionViewHeaderView.h"

#import "AFImageDownloader.h"


#import "PXRequest+Creation.h"

@import ObjectiveC;

@interface AFViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) AFCollectionViewStackedLayout * stackLayout;



@property (nonatomic, strong) AFCollectionViewFlowLayout * flowLayout;



@property (nonatomic, strong) AFCoverFlowFlowLayout * coverFlowLayout;



@property (nonatomic, strong) NSMutableArray *popularPhotos;
@property (nonatomic, strong) NSMutableArray *editorsPhotos;
@property (nonatomic, strong) NSMutableArray *upcomingPhotos;


@property (nonatomic, strong) UICollectionView   *collectionView;


@end


void PrintObjectMethods(NSString *className) {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(NSClassFromString(className),&count);
    for (unsigned int i = 0; i < count; ++ i) {
        SEL sel = method_getName(methods[i]);
        const char *name = sel_getName(sel);
        printf("%s\n", name);
    }
    free(methods);
    
}

@implementation AFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
    [self loadImage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return AFViewControllerNumberSections;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 20;
}


- (UICollectionViewCell *)collectionView: (UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:
                                                           CellIdentifier forIndexPath:indexPath];
    NSArray *array;
    switch (indexPath.section) {
            case AFViewControllerPopularSection:
            array = self.popularPhotos;
            break;
            case AFViewControllerEditorsSection:
            array = self.editorsPhotos;
            break;
            case AFViewControllerUpcomingSection:
            array = self.upcomingPhotos;
        break; }
    if (indexPath.row < array.count) {
        [cell setImage:array[indexPath.item]]; }
    return cell;
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (collectionViewLayout == self.coverFlowLayout) {
        CGFloat margin = 0.0f;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            margin = 130.0f; }
        else {
            margin = 280.0f; }
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if (section == 0) {
            insets.left = margin; }
        else if (section == [collectionView numberOfSections] - 1) {
            insets.right = margin; }
        return insets; }
    else if (collectionViewLayout == self.flowLayout) {
        return self.flowLayout.sectionInset; }
    else {
        // Should never happen.
        return UIEdgeInsetsZero;}
}


- (void)setup {
    
    // Create our view
    // Create instances of our layouts
    self.stackLayout = [[AFCollectionViewStackedLayout alloc]
                        init];
    self.flowLayout = [[AFCollectionViewFlowLayout alloc] init];
    
    self.coverFlowLayout = [[AFCoverFlowFlowLayout alloc] init];
    
    // Create a new collection view with our flow layout and
    // set ourself as delegate and data source.
    UICollectionView *collectionView = [[UICollectionView alloc]
initWithFrame:CGRectZero
collectionViewLayout:self.stackLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // Register our classes so we can use our custom
    // subclassed cell and header
    [collectionView registerClass:[AFCollectionViewCell class]
       forCellWithReuseIdentifier:CellIdentifier];
   // [collectionView registerClass:[AFCollectionViewHeaderView class] forCellWithReuseIdentifier:HeaderIdentifier];
   
    // Set up the collection view geometry to cover the whole // screen in any orientation and other view properties.
    collectionView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    // Finally, set our collectionView (since we are a
    // collection view controller, this also sets self.view) self.collectionView = collectionView;
    // Setup our model
    self.popularPhotos = [NSMutableArray arrayWithCapacity:20];
    self.editorsPhotos = [NSMutableArray arrayWithCapacity:20];
    self.upcomingPhotos = [NSMutableArray arrayWithCapacity:20];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];

}

- (void)loadImage {
    void (^block)(NSDictionary *, NSError *) = ^(NSDictionary *results, NSError *error) {
        NSMutableArray *array;
        NSInteger section = 0;
        if ([[results valueForKey:@"feature"] isEqualToString:@"popular"]) {
            array = self.popularPhotos;
            section = AFViewControllerPopularSection; }
        else if ([[results valueForKey:@"feature"] isEqualToString:@"editors"]) {
            array = self.editorsPhotos;
            section = AFViewControllerEditorsSection; }
        else if ([[results valueForKey:@"feature"] isEqualToString:@"upcoming"]) {
            array = self.upcomingPhotos;
            section = AFViewControllerUpcomingSection; }
        else {
            NSLog(@"%@", [results valueForKey:@"feature"]); }
        NSInteger item = 0;
        for (NSDictionary *photo in [results valueForKey:@"photos"]) {
            NSString *url = [[[photo valueForKey:@"images"]
                              lastObject] valueForKey:@"url"];
            [AFImageDownloader imageDownloaderWithURLString:url autoStart:YES
                                                 completion:^(UIImage *decompressedImage) {
                                                     [array addObject:decompressedImage];
                                                     [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath
                                                                                                     indexPathForItem:item inSection:section]]]; }];
            item++; }
    };

    PrintObjectMethods(@"PXRequest");

    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:20 completion:block];
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeatureEditors resultsPerPage:20
                           completion:block];
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeatureUpcoming resultsPerPage:20
                           completion:block];
    

}




@end
