//
//  ViewController.m
//  DictTest
//
//  Created by Tammina, Manoj on 11/5/15.
//  Copyright (c) 2015 Tammina. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MBProgressHUD.h"

static NSString * const kDictionaryAPIBaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";

@class MBProgressHUD;

@interface ViewController ()

@property(nonatomic,strong) NSArray* outputStrings;
@property (nonatomic,strong) NSMutableArray *finalResult;
@property (nonatomic,strong) NSDictionary *dict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputSearchTerm.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Json Parsing

-(NSMutableArray *)parseTheDataFromArray:(NSArray *)jsonStrings
{
    NSMutableArray *jsonOutputArray=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in jsonStrings) {
        NSArray *lfsArray=[dict valueForKey:@"lfs"];
        
        for (NSDictionary *lfDict in lfsArray) {
            [jsonOutputArray addObject:[lfDict valueForKey:@"lf"]];
        }
    }
    return jsonOutputArray;
}

#pragma mark Async Calls

-(void)processingCallsAsynchronous
{
    
    if(![self.inputSearchTerm.text  isEqual:@""]){
    AFHTTPRequestOperationManager *requestOperationManager=[[AFHTTPRequestOperationManager alloc] init];
    [requestOperationManager GET:kDictionaryAPIBaseURLString parameters:@{@"sf":self.inputSearchTerm.text} success:^(AFHTTPRequestOperation * operarion, id responseObject) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // Background work
                
                
                
                self.outputStrings=responseObject;
                self.finalResult=[self parseTheDataFromArray:self.outputStrings];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *resultsAppended = [self.finalResult componentsJoinedByString:@"\n\n"];
                    if([resultsAppended isEqual: @""])
                        self.outputResults.text= [NSString stringWithFormat:@"No results found for %@.", self.inputSearchTerm.text];
                    else
                        self.outputResults.text=resultsAppended;

                });
            });
            
        } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
            //NSLog(@"Error: %@",error);
            self.outputResults.text=[error localizedDescription];
        }];
    }
   
}

#pragma mark- hide keyboard

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

#pragma mark - Button Action

- (IBAction)Submit:(id)sender {
  
    [self processingCallsAsynchronous];
    
}

- (IBAction)Clear:(id)sender {
    self.inputSearchTerm.text = @"";
    self.outputResults.text = @"";
}
@end
