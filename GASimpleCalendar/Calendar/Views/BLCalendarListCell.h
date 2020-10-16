//
//  BLCalendarListCell.h
//  甲丁
//
//  Created by Gamin on 9/8/20.
//  Copyright © 2020 langdaoTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLCalendarListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (nonatomic ,weak) NSDateComponents *dataModel;
@property (nonatomic ,weak) NSDateComponents *selectModel;
@property (assign, nonatomic) NSInteger sYear; // 切换的年月
@property (assign, nonatomic) NSInteger sMonth;

- (void)initWithObject:(id)object IndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
