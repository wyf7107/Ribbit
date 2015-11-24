//
//  EditFriendsViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic,strong) NSArray *allusers;
@property (nonatomic,strong) PFUser *currentUser;
@property (nonatomic,strong) NSMutableArray *friends;

- (BOOL)isFriend:(PFUser *)user;

@end
