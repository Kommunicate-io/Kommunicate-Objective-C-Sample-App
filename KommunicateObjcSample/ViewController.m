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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userId = @"<pass a user Id>";
    NSString *applicationId = @"<pass your App ID>";
    [Kommunicate setupWithApplicationId:applicationId];
    if(!Kommunicate.isLoggedIn) {
        [KommunicateWrapper.shared connectUserWithUserId:userId password:@"reytum" displayName:nil emailId:nil metadata: nil completion:^(NSString * responseUserId, NSError * connectionError) {
            if(!connectionError) {
                [Kommunicate createConversationWithUserId:userId agentIds:@[] botIds:NULL useLastConversation:YES clientConversationId: nil completion: ^(NSString *clientChannelKey){
                    if(clientChannelKey) {
                        NSLog(@"Client channel key %@", clientChannelKey);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Kommunicate showConversationWithGroupId:clientChannelKey
                                                                from:self
                                                    prefilledMessage:nil
                                                   completionHandler:^(BOOL show) {
                                NSLog(@"conversation shown");
                            }];
                        });
                    }
                }];
            }
        }];
    } else {
        [Kommunicate createConversationWithUserId:userId agentIds:@[] botIds:NULL useLastConversation:YES clientConversationId: nil completion: ^(NSString *clientChannelKey){
            if(clientChannelKey) {
                NSLog(@"Client channel key %@", clientChannelKey);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Kommunicate showConversationWithGroupId:clientChannelKey
                                                        from:self
                                            prefilledMessage:nil
                                           completionHandler:^(BOOL show) {
                        NSLog(@"conversation shown");
                    }];
                });
            }
        }];
    }
}
@end
