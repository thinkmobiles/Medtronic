//
//  WebInfoViewController.h
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-07-19.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "AbstractMedtronicViewController.h"

@interface WebInfoViewController : AbstractMedtronicViewController
<UIWebViewDelegate>{
    NSString * myTitle;
    NSString * fileStr;
}


@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString * myTitle;
@property (nonatomic, retain) NSString * fileStr;


@end
