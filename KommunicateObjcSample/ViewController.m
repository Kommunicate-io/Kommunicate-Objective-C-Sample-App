//
//  ViewController.m
//  KommunicateObjcSample
//
//  Created by Mukesh Thawani on 04/10/18.
//  Copyright © 2018 mukesh. All rights reserved.
//

#import "ViewController.h"
#import "Kommunicate-Swift.h"
#import "KommunicateObjcSample-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ALUser *aluser = [[ALUser alloc] init];
    NSString *userId = "yourUserId"
    aluser.userId = userId;
    NSArray *agentIds = @[];
    [Kommunicate setupWithApplicationId:]
    [KommunicateWrapper.shared connectUserWithUserId:userId password:nil displayName:nil emailId:nil applicationId:<#(NSString * _Nonnull)#> completion:<#^(NSString * _Nullable, NSError * _Nullable)completion#>
        if(!error) {
            [Kommunicate createConversationWithUserId: aluser.userId agentIds:agentIds botIds:nil useLastConversation:YES completion:^(NSString *clientChannelKey){
                if(clientChannelKey) {
                    NSLog(@"Client channel key %@", clientChannelKey);
                    [Kommunicate showConversationWithGroupId:clientChannelKey from:self completionHandler:^(BOOL shown) {
                        NSLog(@"conversation shown");
                    }];
                }
            }];
        }
    }];

    [Kommunicate showConversationsFrom:self];
}


@end
