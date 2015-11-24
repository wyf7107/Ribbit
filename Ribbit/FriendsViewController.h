//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSMutableArray *friends;

@end
