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
    NSString *userId = <pass user Id>
    NSString *applicationId = <pass your applicationID>
    NSArray *agentIds = <pass an array of agentIds>
    [Kommunicate setupWithApplicationId:applicationId];
    if(!Kommunicate.isLoggedIn) {
    [KommunicateWrapper.shared connectUserWithUserId:userId password:nil displayName:nil emailId:nil applicationId:applicationId completion:^(NSString * responseUserId, NSError * connectionError) {
        if(!connectionError) {
            [Kommunicate createConversationWithUserId: userId agentIds:agentIds botIds:nil useLastConversation:YES completion:^(NSString *clientChannelKey){
                if(clientChannelKey) {
                    NSLog(@"Client channel key %@", clientChannelKey);
                    [Kommunicate showConversationWithGroupId:clientChannelKey from:self completionHandler:^(BOOL shown) {
                        NSLog(@"conversation shown");
                    }];
                }
            }];
        }
    }];
    } else {
        [Kommunicate createConversationWithUserId: userId agentIds:agentIds botIds:nil useLastConversation:YES completion:^(NSString *clientChannelKey){
            if(clientChannelKey) {
                NSLog(@"Client channel key %@", clientChannelKey);
                [Kommunicate showConversationWithGroupId:clientChannelKey from:self completionHandler:^(BOOL shown) {
                    NSLog(@"conversation shown");
                }];
            }
        }];
    }
}


@end
