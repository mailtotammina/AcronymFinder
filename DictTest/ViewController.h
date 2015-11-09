//
//  ViewController.h
//  DictTest
//
//  Created by Tammina, Manoj on 11/5/15.
//  Copyright (c) 2015 Tammina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *inputSearchTerm;

- (IBAction)Submit:(id)sender;

- (IBAction)Clear:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *outputResults;

@end


