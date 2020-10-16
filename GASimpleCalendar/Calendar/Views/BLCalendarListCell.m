//
//  BLCalendarListCell.m
//  甲丁
//
//  Created by Gamin on 9/8/20.
//  Copyright © 2020 langdaoTech. All rights reserved.
//

#import "BLCalendarListCell.h"
#import "CommonHeader.h"
#import "GAPublicClass.h"

@implementation BLCalendarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)releaseAction {
    _numLab.text = @"";
    _bgView.hidden = YES;
    _numLab.textColor = HexColor(@"#C9C9C9");
}

- (void)initWithObject:(id)object IndexPath:(NSIndexPath *)indexPath {
    [self releaseAction];
    if (object) {
        _dataModel = object;
        _numLab.text = [NSString stringWithFormat:@"%ld",(long)_dataModel.day];
        // 选择月的日期
        if (_dataModel.year == _sYear && _dataModel.month == _sMonth) {
            _numLab.textColor = HexColor(@"#4A4A4A");
        }
        // 当日日期
        NSDateComponents *curComponents = [GAPublicClass getDateComponentsWithDate:[NSDate date]];
        if (curComponents && (_dataModel.year == curComponents.year && _dataModel.month == curComponents.month && _dataModel.day == curComponents.day)) {
            _bgView.hidden = NO;
            _bgView.backgroundColor = HexColor(@"#D2EDFF");
            _numLab.textColor = HexColor(@"#179EFD");
        }
        // 选择日期
        if (_selectModel && (_dataModel.year == _selectModel.year && _dataModel.month == _selectModel.month && _dataModel.day == _selectModel.day)) {
            _bgView.hidden = NO;
            _bgView.backgroundColor = HexColor(@"#179EFD");
            _numLab.textColor = HexColor(@"#FFFFFF");
        }
    }
}

@end
