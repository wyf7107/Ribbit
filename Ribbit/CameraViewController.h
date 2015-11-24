//
//  CameraViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/18.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *videoFilePath;
@property (nonatomic,strong) NSArray *friends;
@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;
- (void) uploadMessage;
- (UIImage *) resizeImage: (UIImage *)image tiWidth:(float)width andHeight:(float)height;

@end

