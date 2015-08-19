//
//  ViewController.m
//  RottenTomato
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/17/15.
//  Copyright (c) 2015 Li-Erh Chang. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+AFNetworking.h>
#define TEXT_OPEN_OFFSET 90.0
#define TEXT_CLOSE_MAX_HEIGHT 240.0
#define TEXT_MARGIN 15.0

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisView.text = self.movie[@"synopsis"];
    NSString *lowResPosterUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSString *highResPosterUrl = [self.movie valueForKeyPath:@"posters.detailed"];
    highResPosterUrl = [self convertPosterUrlToHighRes:highResPosterUrl];    
    [self.posterView setImageWithURL:[NSURL URLWithString:lowResPosterUrl]];
    [self.posterView setImageWithURL:[NSURL URLWithString:highResPosterUrl]];
    
    self.title = self.movie[@"title"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnTextView:)];
    [self.textView addGestureRecognizer:tap];
    
    CGRect frame = self.synopsisView.frame;
    frame.size.height = self.synopsisView.contentSize.height;
    self.synopsisView.frame = frame;
    self.synopsisView.textContainer.lineFragmentPadding = 0;
    self.synopsisView.textContainerInset = UIEdgeInsetsZero;
}

- (void)handleTapOnTextView:(UITapGestureRecognizer *)recognizer {
    float textCloseOffset = self.screenHeight - TEXT_CLOSE_MAX_HEIGHT;
    float maxHeight = self.screenHeight - TEXT_OPEN_OFFSET;
    float synopsisHeight = self.synopsisView.contentSize.height + TEXT_MARGIN;
    float synopsisOffset = self.synopsisView.frame.origin.y;
    
    if (TEXT_CLOSE_MAX_HEIGHT > synopsisHeight + synopsisOffset) {
        return;
    }
    
    if (self.textView.frame.origin.y == textCloseOffset) {// open the textView
        float height = (maxHeight > synopsisHeight) ? (synopsisHeight + synopsisOffset) : maxHeight;
        float offset = (maxHeight > synopsisHeight) ? (TEXT_OPEN_OFFSET + maxHeight - height) : TEXT_OPEN_OFFSET;
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, offset, self.textView.frame.size.width, height);
        }];
    } else { // close the textView
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(self.textView.frame.origin.x, textCloseOffset, self.textView.frame.size.width, TEXT_CLOSE_MAX_HEIGHT);
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)convertPosterUrlToHighRes:(NSString *)url {
    NSRange range = [url rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *returnValue = url;
    if (range.length > 0) {
        returnValue = [url stringByReplacingCharactersInRange:range withString: @"https://content6.flixster.com/"];
    }
    return returnValue;
}


@end
