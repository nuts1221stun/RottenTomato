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
    self.wrapperView.layer.cornerRadius = 10.0;
    self.wrapperView.layer.borderWidth = 0.0;
    
    /*UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.wrapperView.layer.masksToBounds = NO;
    self.wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.wrapperView.layer.shadowOffset = CGSizeMake(-0.0f, -0.0f);
    self.wrapperView.layer.shadowOpacity = 1.0f;
    self.wrapperView.layer.shadowRadius = 8;
    self.wrapperView.layer.shadowPath = shadowPath.CGPath;*/
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
