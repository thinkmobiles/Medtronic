//
//  InfoViewController.m
//  medtronic
//
//  Created by Hanna Dutkiewicz on 12-06-25.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "InfoViewController.h"
#import "MedtronicAboveNavigationController.h"
#import "AppSettingsViewController.h"
#import "Utils.h"
#import "ButtonView.h"
#import "WebInfoViewController.h"

#define LABEL_TAG 100

@implementation InfoViewController

@synthesize array, titleFromJson;

#pragma mark - View lifecycle

- (void)viewDidLoad{
    isInside = YES;
    [super viewDidLoad];
    
    if (array == nil) {
        [self setTitle:@"Medtronic"];
        [self addSettingsButton];
        
        array = [[NSMutableArray alloc] init];
        NSData * data = [Utils dataFromFile:@"pomoc"];
        if (data) {
            NSDictionary * dict = [Utils getJSONFromData: data];
            if (dict) {
                NSArray * arr = [dict objectForKey:@"views"];
                for (NSDictionary * smallDict in arr) {
                    ButtonView * newButton = [[ButtonView alloc] initWithJson:smallDict];
                    [array addObject: newButton];
                }
            }
        }
    }
    if(titleFromJson){
        [[self myRealNavigationItem] setTitle: titleFromJson];
    }
}

- (void) addSettingsButton{
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [add setImage: [UIImage imageNamed:@"sets_button.png"] forState:UIControlStateNormal];
    [add setImage: [UIImage imageNamed:@"sets_button_s.png"] forState:UIControlStateHighlighted];
    [add setFrame: CGRectMake(0, 0, [UIImage imageNamed:@"sets_button.png"].size.width, [UIImage imageNamed:@"sets_button.png"].size.height)];
    
    UIBarButtonItem * plus = [[UIBarButtonItem alloc] initWithCustomView: add];
    [add addTarget:self action:@selector(settingsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self myRealNavigationItem] setRightBarButtonItem: plus];
}

- (IBAction) settingsClicked:(id)sender{
    NSArray * arr = [[NSBundle mainBundle] loadNibNamed:@"MedtronicAppSettingsController" owner:nil options:nil];
    UINavigationController * navController = [arr objectAtIndex:0];
    
    MedtronicAboveNavigationController * above = [[navController viewControllers] objectAtIndex:0];
    above.rootView = [[AppSettingsViewController alloc] initWithNibName:@"AppSettingsViewController" bundle:nil];
    
    [self.tabBarController presentViewController: navController animated: YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ButtonView * butt = [array objectAtIndex: [indexPath row]];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableRow"];

    
    if (!cell) {
        NSArray * objects = [[NSBundle mainBundle] loadNibNamed:@"InfoTableRow" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
    }
    [cell setBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"table_bkg_info.png"]] ];
    [cell setSelectedBackgroundView: [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"table_bkg_info_s.png"]]];
    
    
    UILabel * label = (UILabel *)[cell viewWithTag: LABEL_TAG];
    //[label setTextColor: [UIColor colorWithRed:60.0f/255.0f green:95.0f/255.0f blue:165.0f/255.0f alpha:1.0f]];
    [label setText: butt.text];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ButtonView * butt = [array objectAtIndex: [indexPath row]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([butt.buttonsViews count] > 0) {
        
        InfoViewController * info = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
        info.titleFromJson = butt.text;
        info.array = butt.buttonsViews;
        [[self myRealNavigationController] pushViewController: info animated:YES];
        return;
    }
    else if(butt.file){
        WebInfoViewController * webInfo = [[WebInfoViewController alloc] initWithNibName:@"WebInfoViewController" bundle:nil];
        webInfo.isInside = YES;
        webInfo.fileStr = butt.file;
        webInfo.myTitle = butt.text;
        [[self myRealNavigationController] pushViewController: webInfo animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

@end
