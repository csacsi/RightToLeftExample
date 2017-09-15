//
//  SampleCollectionViewCell.m
//  arabic
//
//  Created by Csaba Toth on 2017. 09. 14..
//  Copyright © 2017. Skyscanner. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "SampleCollectionViewCell.h"
@interface SampleCollectionViewCell()
{
    UILabel *_title;
}
@end

@implementation SampleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        _title = [UILabel new];
        [_title setTextAlignment:NSTextAlignmentCenter];
        [_title setText:@"Title title title"];
        [self.contentView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    [_title setText:title];
}
@end
