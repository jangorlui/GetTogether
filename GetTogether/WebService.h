//
//  WebService.h
//  ASIHTTPKit
//
//  Created by mac on 5/8/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface WebService : NSObject<UIAlertViewDelegate>{
    ASIFormDataRequest *m_request;
}

@property(nonatomic,retain)ASIFormDataRequest *request;
@property(assign)BOOL showResponseToLog;

- (void)setRequestMethod:(NSString *)mehtod shareSession:(BOOL) yesOrNo;
- (void)requestStart:(id)requestDelegate;
- (void)requestDidSuccess:(ASIHTTPRequest *)request;
- (void)requestDidFailed:(ASIHTTPRequest *)request;
- (NSDictionary *)jsonToDictionary:(NSString *) jsonString;
- (NSDictionary *)checkData:(NSDictionary *) rootDictionary;
@end

