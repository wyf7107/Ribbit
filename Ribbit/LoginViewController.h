//
//  LoginViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)login:(id)sender;




@end
