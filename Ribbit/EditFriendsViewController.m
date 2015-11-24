//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "MSCellAccessory.h"

UIColor *disclosureColor;

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error: %@ %@",error,[error userInfo]);
        }else{
            self.allusers = objects;
            [self.tableView reloadData];
        }
    }];
    
    self.currentUser = [PFUser currentUser];
    
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allusers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    }else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    if ([self isFriend:user]) {
        cell.accessoryView = nil;
        
        for (PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        
        [friendsRelation removeObject:user];
        
    }else{
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];;
        [self.friends addObject:user];
        [friendsRelation addObject:user];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@, %@",error, [error userInfo]);
        }
    }];
    
}

- (BOOL)isFriend:(PFUser *)user{
    for (PFUser *friend in self.friends){
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}




@end
