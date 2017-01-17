//
//  MBDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MBDataSource.h"
#import "MBTableViewCell.h"

@implementation MBDataSource

- (id)initWithModels:(NSArray *)models Identifier:(NSString *)identifier {
    
    self = [super init];
    if (self) {
        
        self.models     = models;
        self.identifier = identifier;
    }
    
    return self;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.models[(NSUInteger) indexPath.section];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    [cell configureCellWithModel:[self modelAtIndexPath:indexPath]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.models.count;
}
@end
