//
//  MessageDataSource.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/20.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MessageDataSource.h"

@implementation MessageDataSource

- (id)initWithModels:(NSArray *)models withIdentifier:(NSString *)identifer {
    
    self = [super init];
    if (self) {
        
        self.models     = models;
        self.identifier = identifer;
    }
    
    return self;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.models[indexPath.section];
}

#pragma mark - TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:self.identifier];
    }
    
    //获取model
    id model = [self modelAtIndexPath:indexPath];
    
    //设置cell内容
    cell.textLabel.text       = [model valueForKey:@"Title"];
    cell.textLabel.font       = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = [model valueForKey:@"Detail"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.models.count;
}

@end
