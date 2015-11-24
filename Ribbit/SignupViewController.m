//
//  SignupViewController.m
//  Ribbit
//
//  Created by Yifan Wang on 15/11/16.
//  Copyright © 2015年 Yifan Wang. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>


@interface SignupViewController ()


@end



@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length]==0 || [password length]==0 || [email length]==0) {
        UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please make sure you fill out all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
    }else{
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle:@"Try Again!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextfield Delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
