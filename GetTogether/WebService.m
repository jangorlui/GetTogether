//
//  WebServer.m
//  ASIHTTPKit
//
//  Created by mac on 5/8/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//

#import "WebService.h"
#import "SBJson.h"

#define kAlertTagOperationError         0
#define kAlertTagNetwrokError           1
#define kAlertTagNeedToLoginError          3
#define kDeviceTypeKey                 @"DEVICE_TYPE"
#define kDeviceTypeValue               @"31"
#define kHTTPUsername                  @"test"
#define kHTTPPassword                  @"5179"
#define kHTTPHost                      @"http://mobile.chnlove.com"
#define UserAgent    @"Mozil1a/4.0 (compatible; MS1E 7.0; Windows NT 6.1; WOW64; )"

@implementation WebService

@synthesize showResponseToLog=m_showResponseToLog;
@synthesize request=m_request;

- (id)init{
    self=[super init];
    
    if (self) {
    }
    
    return self;
}


- (void)setRequestMethod:(NSString *)mehtod shareSession:(BOOL) shared{
    if (self) {
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",kHTTPHost,mehtod];
        NSURL *url=[NSURL URLWithString:urlStr];
        m_request=[[ASIFormDataRequest alloc] initWithURL:url];
        [m_request setUserAgent:UserAgent];
        
        NSMutableDictionary *header=[[NSMutableDictionary alloc] init];
        [header setValue:kDeviceTypeValue forKey:kDeviceTypeKey];
        
        [m_request setRequestHeaders:header];
        [header release];
        
        if (![kHTTPUsername isEqualToString:@""]) {
            [m_request setUsername:kHTTPUsername];
        }
        if (![kHTTPPassword isEqualToString:@""]) {
            [m_request setPassword:kHTTPPassword];
        }
    }
}

- (void)requestStart:(id)requestDelegate{
    m_showResponseToLog=YES;
}


- (void)requestDidSuccess:(ASIHTTPRequest *)request{
    NSLog(@"-----requestDidSuccess-----RequestHeaders:%@",[[request requestHeaders] description]);
    
    if (m_showResponseToLog) {
        NSLog(@"WebService:请求成功");
        NSString *str=[[NSString alloc] initWithData:[m_request postBody] encoding:NSUTF8StringEncoding];
        NSLog(@"\n\nURL:\n%@?%@\n\n",[request url],str);
        [str release];
    }
    
    NSString *responseStr=[m_request responseString];
    
    if (responseStr!=nil) {
        
        NSDictionary *dict=[self jsonToDictionary:responseStr];
        if (dict!=nil&&![dict isKindOfClass:[NSNull class]]) {
            NSNumber *result=[dict objectForKey:@"result"];
            NSString *errmsg=[dict objectForKey:@"errmsg"];
            NSString *errnum=[dict objectForKey:@"errno"];
            NSString *a = @"";
            if (![result boolValue]) {
                
                BOOL isSpecial = NO;
                if ([errnum isEqualToString:@"MBCE1004"]) {
                    a = @"We are unable to process your login. \n\n There are two possible reasons:                                                            1.The service of this site is currently not available in your country.                                                            2.The site provides direct services to male members only.";
                    isSpecial = YES;
                }else{
                    a = [errmsg stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                }
                
                if (a.length==0||[a isEqualToString:@""]) {
                    a = @"System is busy. Try later!";
                }
                
                NSString *title =isSpecial?@"Sorry":@"Error";
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:a delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                if ([errnum isEqualToString:@"MBCE0003"]) {
                    [alert setTag:kAlertTagNeedToLoginError];
                }else{
                    [alert setTag:kAlertTagOperationError];
                }
                if (isSpecial) {
                    [self changeAlertTextAlign:alert];
                }
                [alert show];
                [alert release];
            }
        }
    }    
}

- (void)changeAlertTextAlign:(UIAlertView *)alter{
    NSArray *array=[alter subviews];
    for (int i = 0;i<[array count];i++) {
        UIView *view = (UIView *)[array objectAtIndex:i];
        UILabel *l = (UILabel *)view;
        l.font = [UIFont systemFontOfSize:12.0f];
        if (i==1) {
            
            l.textAlignment = NSTextAlignmentLeft;
        }
        
    }
}


- (void)requestDidFailed:(ASIHTTPRequest *)request{
        
        if (m_showResponseToLog) {
            NSLog(@"WebService:请求失败");
            NSString *str=[[NSString alloc] initWithData:[m_request postBody] encoding:NSUTF8StringEncoding];
            NSLog(@"\n\nURL:\n%@?%@\n\n",[request url],str);
            [str release];
            NSLog(@"String:%@",[request responseString]);
            NSLog(@"status Message:%@",[request responseStatusMessage]);
            NSLog(@"request error: %@",[request error]);
            NSLog(@"request info: %@",[request userInfo]);
    }
}


- (NSDictionary *)jsonToDictionary:(NSString *) jsonString{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict=[jsonParser objectWithString:jsonString];
    
    if (m_showResponseToLog) {
        NSLog(@"\nJSON:\n%@\n\nDICT:\n%@",jsonString,[dict description]);
    }
    
    [jsonParser release];
    
    return dict;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==kAlertTagOperationError) {
        if (buttonIndex==0) {
        }
    }else if(alertView.tag==kAlertTagNeedToLoginError){
        if (buttonIndex==0) {
            UIViewController *viewController=(UIViewController *)[[UIApplication sharedApplication] delegate];
            [viewController.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


- (NSString *) checkResult:(NSString *)obj{
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        NSString *str=(NSString *)obj;
        if ([str length]<=0) {
            return @"";
        }
    }
    
    return obj;
}

- (NSDictionary *)checkData:(NSDictionary *) rootDictionary{
    id dataObj=[rootDictionary objectForKey:@"data"];
    
    NSDictionary *dict=nil;
    
    if (dataObj!=nil&&[dataObj isKindOfClass:[NSDictionary class]]) {
        dict=(NSDictionary *)dataObj;
    }
    
    return dict;
}

-(void)dealloc{
    [m_request clearDelegatesAndCancel];
    [m_request release];
    [super dealloc];
}

@end

