//
//  PersonDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2017/1/2.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "PersonDataSource.h"

@implementation PersonDataSource

- (instancetype)initWithArray:(NSArray *)array Identifier:(NSString *)identifier {
    
    self = [super init];
    if (self) {
        
        self.array      = array;
        self.identifier = identifier;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.identifier];
    }
    cell.textLabel.text = self.array[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
