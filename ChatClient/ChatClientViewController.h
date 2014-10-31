//
//  ChatClientViewController.h
//  ChatClient
//
//  Created by Levi.duan on 10/16/14.
//  Copyright (c) 2014 iDreamsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatClientViewController : UIViewController{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}
@end
