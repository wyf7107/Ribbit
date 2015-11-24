//
//  CameraViewController.m
//  Ribbit
//
//  Created by Yifan Wang on 15/11/18.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MSCellAccessory.h"

@interface CameraViewController ()

@end

@implementation CameraViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipients = [[NSMutableArray alloc] init];
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@ %@",error,[error userInfo]);
        }else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];

    
    if (self.image== nil && [self.videoFilePath length]==0) {
        [super viewWillAppear:animated];
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
    
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
        }
    }



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friends count];
}


#pragma mark - image picker controller delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //a photo is taken or selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        
    }else{
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
               UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
           }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self.recipients containsObject:user.objectId]){
        UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    }else{
        cell.accessoryView = nil;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (cell.accessoryView == nil) {
        UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];;
        [self.recipients addObject:user.objectId];
        
    }else{
        cell.accessoryView = nil;
        [self.recipients removeObject:user.objectId];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)send:(id)sender {
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try Again" message:@"Please capture or select a phone or video to share!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }else{
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
    
}


- (void)uploadMessage{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image tiWidth:750.0f andHeight:1334.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
    }else{
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured!" message:@"Please try sending again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured!" message:@"Please try sending again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }else{
                    [self reset];
                }
            }];
        }
    }];
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

- (UIImage *)resizeImage:(UIImage *)image tiWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}




@end
