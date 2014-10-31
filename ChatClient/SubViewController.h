//
//  SubViewController.h
//  ChatClient
//
//  Created by Levi.duan on 10/16/14.
//  Copyright (c) 2014 iDreamsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubViewController : UIViewController{
    NSMutableArray *messages;
}

- (void)transferOutput:(NSOutputStream *)outputStream;
- (void)transferInput:(NSInputStream *)inputStream;
@end
