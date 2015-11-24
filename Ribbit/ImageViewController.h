//
//  imageViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/21.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic,strong) PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
