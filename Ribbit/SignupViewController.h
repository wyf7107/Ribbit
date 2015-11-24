//
//  SignupViewController.h
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)signup:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
