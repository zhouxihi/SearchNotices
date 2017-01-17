//
//  MoreCategoryDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/25.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MoreCategoryDataSource.h"
#import "MoreCategoryTableCell.h"

@implementation MoreCategoryDataSource

- (id)initWithModels:(NSArray *)models withIdentifier:(NSString *)cellIdentifier {
    
    self = [super init];
    if (self) {
        
        self.models         = models;
        self.cellIdentifier = cellIdentifier;
    }
    
    return self;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.models objectAtIndex:indexPath.section];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                                  forIndexPath:indexPath];
    
    [cell configureWithModel:[self modelAtIndexPath:indexPath]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
