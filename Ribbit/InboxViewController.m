//
//  InboxViewController.m
//  Ribbit
//
//  Created by Yifan Wang on 15/11/15.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//


#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "MSCellAccessory.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
}


- (void)retrieveMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@ %@", error, [error userInfo]);
        }else{
            self.messages = objects;
            [self.tableView reloadData];
        }
        
        if([self.refreshControl isRefreshing]){
            [self.refreshControl endRefreshing];
        }
    }];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        NSLog(@"Current User: %@",currentUser.username);
        
        [self retrieveMessages];
        
    }else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
    
    
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }else{
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    if ([recipientIds count] == 1) {
        [self.selectedMessage delete];
    }else{
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }

}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        segue.destinationViewController.hidesBottomBarWhenPushed = YES;
    }else if ([segue.identifier isEqualToString:@"showImage"]){
        segue.destinationViewController.hidesBottomBarWhenPushed = YES;
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
        
        
    }
}



@end
