//
//  RestHelper.m
//  RestApi
//
//  Created by kita on 14-5-8.
//  Copyright (c) 2014年 kita. All rights reserved.
//

#import "RestHelper.h"
#import "AFNetworking.h"
#import "RACAFNetworking.h"

#define kAuthorizePath @"/login"


#define kHTTPHeaderCookieName   @"Set-Cookie"
#define kHTTPHeaderCsrftoken    @"csrftoken"

#define kHTTPCookie         @"jp.co.dreamarts.smart.sdk.cookie"
#define kHTTPCsrfToken      @"jp.co.dreamarts.smart.sdk.csrftoken"
#define kHTTPCookieName     @"ShotEyesWeb.sid"

@interface RestHelper () <UIWebViewDelegate>
@property RACSubject *authSignal;
@end

@implementation RestHelper

+(RestHelper *)sharedInstance
{
    static RestHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance) {
            instance = [[RestHelper alloc] init];
        }
    });
    return instance;
}


+(BOOL)isLogin
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSURL *url = [NSURL URLWithString:[RestHelper getServerAddress]];
    NSArray *cookieArray=[cookieStorage cookiesForURL:url];
    
    BOOL isLogin = NO;
    
    for ( NSHTTPCookie *cookie in cookieArray) {
        if ([kHTTPCookieName isEqualToString:cookie.name] && cookie.value) {
            isLogin = YES;
        }
    }
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kHTTPCookie]) {
//        return YES;
//    }
    
    return isLogin;
}


#pragma mark - authorize
- (RACSignal*)authorize {
    UIWindow* window = UIApplication.sharedApplication.windows[0];
    UIView* view = [window.rootViewController view];
    return [self authorizeInView:view];
}

-(RACSignal *)authorizeInView:(UIView *)view
{
    UIWebView* webview = [[UIWebView alloc] init];
    webview.delegate = self;
    [webview loadRequest:self.authorizeRequest];
    
    [view addSubview:webview];
    webview.frame = view.frame;
    
    self.authSignal = [RACSubject subject];
    return [self.authSignal finally:^{
        webview.delegate = nil;
        [webview removeFromSuperview];
    }];
}

- (NSURLRequest*)authorizeRequest {
    NSString *url = [[RestHelper getServerAddress] stringByAppendingString:kAuthorizePath];
    NSURLComponents* comp = [NSURLComponents componentsWithString:url];
    
    return [[NSURLRequest alloc] initWithURL:comp.URL];
}


#pragma mark - webView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return TRUE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.authSignal sendError:error];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    
    if ([[[RestHelper getServerAddress] stringByAppendingString:kAuthorizePath] isEqualToString:[NSString stringWithFormat:@"%@", webView.request.URL]]) {
        NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
        NSDictionary *headers = [(NSHTTPURLResponse*)resp.response allHeaderFields];
        NSLog(@"%@",@"=======headers======");
        NSLog(@"%@", headers);
        NSString *cookie = [headers objectForKey:kHTTPHeaderCookieName];
        NSString *csrftoken = [headers objectForKey:kHTTPHeaderCsrftoken];
        
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSLog(@"%@",@"=======Cookie======");
        for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
            NSLog(@"cookie name=%@", cookie.name);
            NSLog(@"cookie value=%@", cookie.value);
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if (cookie != nil) {
            [ud setObject:cookie forKey:kHTTPCookie];
        }
        if (csrftoken != nil) {
            [ud setObject:csrftoken forKey:kHTTPCsrfToken];
        }
        //        [ud synchronize];
//        NSLog(@"#####%@", [[NSUserDefaults standardUserDefaults] objectForKey:kHTTPCookie]);
//        NSLog(@"#####%@", cookie);
        
        [self.authSignal sendCompleted];
    }
}

#pragma mark -

+ (NSString *) getServerAddress
{
    return [RestHelper getServerAddress:NO];
}

+ (NSString *) getServerHost
{
    return @"127.0.0.1";
}

+ (NSString *) getServerAddress:(BOOL)isSecure
{
    NSString *protocal = isSecure ? @"https" : @"http";
    NSString *address = [RestHelper getServerHost];
    NSInteger port = 3000;
    
    
    NSString *url = [NSString stringWithFormat:@"%@://%@", protocal, address];
    if (port == 80) {
        return url;
    } else {
        return [url stringByAppendingFormat:@":%d", port];
    }
}

@end
