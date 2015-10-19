//
//  WebInfoViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-19.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "WebInfoViewController.h"
#import "Utils.h"

@implementation WebInfoViewController
@synthesize webView, myTitle, fileStr;


- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource: fileStr ofType:@"html"];
    NSError * error = nil;
    
    NSLog(@"file: %@", filePath);
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: &error];
    
    [webView loadHTMLString: str baseURL:baseURL];

    
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileStr ofType:@"html"]isDirectory:NO]]];
    [[self myRealNavigationItem] setTitle: myTitle];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL: request.URL];
        return NO;
    }
    else{
        return YES;
    }
}

@end
