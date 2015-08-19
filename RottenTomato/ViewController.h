//
//  ViewController.h
//  RottenTomato
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/17/15.
//  Copyright (c) 2015 Li-Erh Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisView;

@property (strong, nonatomic) NSDictionary *movie;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@end

