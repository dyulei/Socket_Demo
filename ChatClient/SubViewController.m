//
//  SubViewController.m
//  ChatClient
//
//  Created by Levi.duan on 10/16/14.
//  Copyright (c) 2014 iDreamsky. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()<UITableViewDataSource,UITableViewDelegate, NSStreamDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SubViewController{
    NSOutputStream *myoutputStream;
    NSInputStream *myinputStream;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messages = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    myoutputStream.delegate = self;
    myinputStream.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [self initNetworkCommunication];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessageAction:(id)sender {
    NSString *response = [NSString stringWithFormat:@"msg:%@", self.myTextField.text];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    
    [myoutputStream write:[data bytes] maxLength:[data length]];
    NSLog(@"%@", response);
    self.myTextField.text = @"";
}

- (void)transferOutput:(NSOutputStream *)outputStream{
    myoutputStream = outputStream;
}

- (void)transferInput:(NSInputStream *)inputStream{
    myinputStream = inputStream;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messages.count;
    NSLog(@"%d", messages.count);
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return messages.count;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *s = (NSString *)[messages objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    return cell;
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent{
    NSLog(@"stream event %lu", streamEvent);
    
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"open");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if(theStream == myinputStream){
                uint8_t buffer[1024];
                int len;
                NSLog(@"%@", theStream);
                while([myinputStream hasBytesAvailable]){
                    len = [myinputStream read:buffer maxLength:sizeof(buffer)];
                    if(len > 0){
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if(nil != output){
                            [self messageReceived:output];
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
                
            }
            break;
            
        case NSStreamEventErrorOccurred:
            break;
        
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        default:
            NSLog(@"Unknown event");
    }
}

-(void)messageReceived:(NSString *)message{
    [messages addObject:message];
    [self.myTableView reloadData];
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
