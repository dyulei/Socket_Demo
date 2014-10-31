//
//  ChatClientViewController.m
//  ChatClient
//
//  Created by Levi.duan on 10/16/14.
//  Copyright (c) 2014 iDreamsky. All rights reserved.
//

#import "ChatClientViewController.h"
#import "SubViewController.h"

@interface ChatClientViewController ()<NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputNameField;
@property (strong, nonatomic) IBOutlet UIView *joinView;
@property (weak, nonatomic) IBOutlet UIButton *joinChat;

@end

@implementation ChatClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNetworkCommunication];
    inputStream.delegate = self;
    outputStream.delegate = self;
    // Do any additional setup after loading the view from its nib.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNetworkCommunication{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(nil, (CFStringRef)@"192.168.105.68", 80, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (IBAction)chatAction:(id)sender {
    NSString *response = [NSString stringWithFormat:@"iam:%@", self.inputNameField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    NSLog(@"%@", response);
    SubViewController *subview = [[SubViewController alloc] initWithNibName:@"SubViewController" bundle:nil];
    [subview transferOutput:outputStream];
    [subview transferInput:inputStream];
    [self presentViewController:subview animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
