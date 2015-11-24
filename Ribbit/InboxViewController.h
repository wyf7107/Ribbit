//
//  InboxViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/15.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController
@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) PFObject *selectedMessage;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) UIRefreshControl *refreshControl;


- (IBAction)logOut:(id)sender;

@end
