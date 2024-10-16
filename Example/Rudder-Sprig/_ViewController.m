//
//  _ViewController.m
//  Rudder-Sprig
//
//  Created by arnabp92 on 02/11/2020.
//  Copyright (c) 2020 arnabp92. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>

@interface _ViewController ()

@end

@implementation _ViewController

RSClient *client;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    client = [RSClient sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)identifyAction:(UIButton *)sender {
    [client identify:@"Test_User_1" traits: @{@"email": @"test@rudderstack.com", @"firstName": @"First", @"lastName": @"Last"}];
}

- (IBAction)trackAction:(UIButton *)sender {
    [client track:@"Track Without Properties"];
}

- (IBAction)resetAction:(UIButton *)sender {
    [client reset:YES];
}

@end
