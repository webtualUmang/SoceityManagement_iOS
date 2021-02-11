//
//  Message.m
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 6/3/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import "MessageChatRoom.h"

@implementation MessageChatRoom
@synthesize attributes,text,date,fromMe,media,thumbnail,type,resultData;

- (id)init
{
    if (self = [super init]) {
        self.date = [NSDate date];
    }
    
    return self;
}

@end
