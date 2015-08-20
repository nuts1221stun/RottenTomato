//
//  MovieCell.m
//  RottenTomato
//
//  Created by Li-Erh å¼µåŠ›å…’ Chang on 8/17/15.
//  Copyright (c) 2015 Li-Erh Chang. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    // rounded corner
    self.wrapperView.layer.masksToBounds = NO;
    self.wrapperView.layer.cornerRadius = 8.0;
    self.wrapperView.layer.borderWidth = 0.5;
    self.wrapperView.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8].CGColor;
    self.wrapperView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.posterView.image = nil;
}


@end
