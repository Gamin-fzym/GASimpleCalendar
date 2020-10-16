//
//  BLCalendarViewController.m
//  甲丁
//
//  Created by Gamin on 9/7/20.
//  Copyright © 2020 langdaoTech. All rights reserved.
//

#import "BLCalendarViewController.h"
#import "MCDatePickerView.h"
#import "GAPublicClass.h"
#import "NSDate+Extension.h"
#import "BLCalendarListCell.h"
#import "CommonHeader.h"

@interface BLCalendarViewController () <MCDatePickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *showBut;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (assign, nonatomic) NSInteger sYear; // 切换的年月
@property (assign, nonatomic) NSInteger sMonth;
@property (strong, nonatomic) NSMutableArray *showMArr;
@property (strong, nonatomic) NSDateComponents *selectModel;
@property (assign, nonatomic) NSInteger calRow; // 日历行数
@property (assign, nonatomic) NSInteger selectRow;// 选择model或今日所在行数

@end

@implementation BLCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectModel = [GAPublicClass getDateComponentsWithDate:[NSDate date]];
    if (self.SelectDateBlock) {
        self.SelectDateBlock(_selectModel);
    }
    NSString *nowTime = [GAPublicClass getNowTimeWithFormat:@"yyyy-MM"];
    [self didSelectDateResult:nowTime ViewTag:6700];
}

- (IBAction)SelectDateAction:(id)sender {
    NSString *tempTime = @"";
    if (_sYear>0 && _sMonth>0) {
        tempTime = [NSString stringWithFormat:@"%04ld-%02ld",(long)_sYear,(long)_sMonth];
    }
    MCDatePickerView *monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:XMGStyleTypeYearAndMonth WithDafultDateStr:tempTime];
    monthView.delegate = self;
    monthView.tag = 6700;
    [monthView show];
}

#pragma mark ----MJDatePickerDelegate

- (void)didSelectDateResult:(NSString *)resultDate ViewTag:(NSInteger)tag {
    if (resultDate) {
        NSArray *array = [resultDate componentsSeparatedByString:@"-"];
        if (array.count >= 2) {
            _sYear = [[array objectAtIndex:0] integerValue];
            _sMonth = [[array objectAtIndex:1] integerValue];
            _timeLab.text = [NSString stringWithFormat:@"%@年%@月",[array objectAtIndex:0],[array objectAtIndex:1]];
            [self dealwithShowData];
        }
    }
}

- (void)dealwithShowData {
    NSString *tempFirstStr = [NSString stringWithFormat:@"%04ld-%02ld-01 12:00",(long)_sYear,(long)_sMonth];
    /// 当月数据
    NSDate *curFirstDate = [GAPublicClass getDateWithStringTime:tempFirstStr andFomatter:@"yyyy-MM-dd HH:mm"];
    NSInteger curDayNum = [GAPublicClass getDaysInMonthWithDate:curFirstDate];
    NSDateComponents *curComponents = [GAPublicClass getDateComponentsWithDate:curFirstDate];
    NSInteger a = [self changeWeekNumWithWeekday:curComponents.weekday];
    
    NSString *tempLastStr = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 12:00",(long)_sYear,(long)_sMonth,(long)curDayNum];
    NSDate *curLastDate = [GAPublicClass getDateWithStringTime:tempLastStr andFomatter:@"yyyy-MM-dd HH:mm"];
    NSDateComponents *curLastComponents = [GAPublicClass getDateComponentsWithDate:curLastDate];
    NSInteger b = [self changeWeekNumWithWeekday:curLastComponents.weekday];
    /// 展示的数组
    if (!_showMArr) {
        _showMArr = [NSMutableArray new];
    }
    [_showMArr removeAllObjects];
    for (int i = 0 ; i < curDayNum ; i ++) {
        NSString *tempTime = [NSString stringWithFormat:@"%04ld-%02ld-%02d 12:00",(long)curComponents.year,(long)curComponents.month,i+1];
        NSDate *tempTimeDate = [GAPublicClass getDateWithStringTime:tempTime andFomatter:@"yyyy-MM-dd HH:mm"];
        [_showMArr addObject:[GAPublicClass getDateComponentsWithDate:tempTimeDate]];
    }
    /// 上月数据
    NSDate *thisFirstDate = [GAPublicClass getPriousorLaterDateFromDate:curFirstDate withMonth:-1];
    NSInteger thisDayNum = [GAPublicClass getDaysInMonthWithDate:thisFirstDate];
    NSDateComponents *thisComponents = [GAPublicClass getDateComponentsWithDate:thisFirstDate];
    for (int i = 0 ; i < a-1 ; i ++) {
        NSString *tempTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 12:00",(long)thisComponents.year,(long)thisComponents.month,thisDayNum-i];
        NSDate *tempTimeDate = [GAPublicClass getDateWithStringTime:tempTime andFomatter:@"yyyy-MM-dd HH:mm"];
        [_showMArr insertObject:[GAPublicClass getDateComponentsWithDate:tempTimeDate] atIndex:0];
    }
    /// 下月数据
    NSDate *nextFirstDate = [GAPublicClass getPriousorLaterDateFromDate:curFirstDate withMonth:1];
    //NSInteger nextDayNum = [GAPublicClass getDaysInMonthWithDate:nextFirstDate];
    NSDateComponents *nextComponents = [GAPublicClass getDateComponentsWithDate:nextFirstDate];
    for (int i = 0 ; i < 7-b ; i ++) {
        NSString *tempTime = [NSString stringWithFormat:@"%04ld-%02ld-%02d 12:00",(long)nextComponents.year,(long)nextComponents.month,i+1];
        NSDate *tempTimeDate = [GAPublicClass getDateWithStringTime:tempTime andFomatter:@"yyyy-MM-dd HH:mm"];
        [_showMArr addObject:[GAPublicClass getDateComponentsWithDate:tempTimeDate]];
    }
    /// 第一次不改变
    _calRow = _showMArr.count/7;
    if (_showBut.selected) {
        NSInteger row = _calRow?:5;
        float h = row * 44.0;
        _collectionHConstraint.constant = h;
    }
    /// 选择的model或当天是否在这个数组里，在第几行
    [self selectRowAction];
    [self scrollViewDidScroll:_collectionView];
    
    [_collectionView reloadData];
}

- (void)selectRowAction {
    /// 选择的model或当天是否在这个数组里，在第几行
    NSInteger selectRow = -1;
    NSInteger todayRow = 0;
    NSDateComponents *todayComponents = [GAPublicClass getDateComponentsWithDate:[NSDate date]];
    for (int i = 0 ; i < _showMArr.count ; i ++) {
        NSDateComponents *com = [_showMArr objectAtIndex:i];
        if (com.year == _selectModel.year && com.month == _selectModel.month && com.day == _selectModel.day) {
            selectRow = (i+1)/7;
            if ((i+1)%7 > 0) {
                selectRow = selectRow + 1;
                break;
            }
        }
        if (com.year == todayComponents.year && com.month == todayComponents.month && com.day == todayComponents.day) {
            todayRow = (i+1)/7;
            if ((i+1)%7 > 0) {
                todayRow = todayRow + 1;
            }
        }
    }
    if (selectRow == -1) {
        selectRow = todayRow;
    }
    _selectRow = selectRow;
}

// i=周几
- (NSInteger)changeWeekNumWithWeekday:(NSInteger)weekday {
    NSInteger i = 1;
    if (weekday == 1) {
        i = 7;
    } else if (weekday == 2) {
        i = 1;
    } else if (weekday == 3) {
        i = 2;
    } else if (weekday == 4) {
        i = 3;
    } else if (weekday == 5) {
        i = 4;
    } else if (weekday == 6) {
        i = 5;
    } else if (weekday == 7) {
        i = 6;
    }
    return i;
}

- (NSString *)getFormatTimeString {
    NSString *tempTime;
    if (_selectModel) {
        tempTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)_selectModel.year,(long)_selectModel.month,(long)_selectModel.day];
    }
    return tempTime;
}

- (float)getHeaderHeight {
    [self.view layoutIfNeeded];
    CGRect lineRect = _lineView.frame;
    return CGRectGetMaxY(lineRect);
}

- (IBAction)tapShowMoreAction:(id)sender {
    if (_showBut.isSelected) {
        _showBut.selected = NO;
        _collectionHConstraint.constant = 44.0;
        if (self.ChangeShowStatusBlock) {
            self.ChangeShowStatusBlock(NO);
        }
        [self scrollViewDidScroll:_collectionView];
    } else {
        _showBut.selected = YES;
        NSInteger row = _calRow?:5;
        float h = row * 44.0;
        _collectionHConstraint.constant = h;
        if (self.ChangeShowStatusBlock) {
            self.ChangeShowStatusBlock(YES);
        }
    }
}

- (void)takeBackView {
    if (_showBut.isSelected) {
        [self tapShowMoreAction:_showBut];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _showMArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"BLCalendarListCell";
    UINib *cellNib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    BLCalendarListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDateComponents *tmodel;
    if (indexPath.row < _showMArr.count) {
        tmodel = _showMArr[indexPath.row];
    }
    cell.selectModel = _selectModel;
    cell.sYear = self.sYear;
    cell.sMonth = self.sMonth;
    [cell initWithObject:tmodel IndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BLCalendarListCell *cell = (BLCalendarListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dataModel) {
        _selectModel = cell.dataModel;
        if (self.SelectDateBlock) {
            self.SelectDateBlock(_selectModel);
        }
        // 选择了非本月的日期时
        if (!(_selectModel.year == _sYear && _selectModel.month == _sMonth)) {
            _sYear = _selectModel.year;
            _sMonth = _selectModel.month;
            [self didSelectDateResult:[NSString stringWithFormat:@"%04ld-%02ld",(long)_sYear,(long)_sMonth] ViewTag:6700];
        } else {
            /// 选择的model或当天是否在这个数组里，在第几行
            [self selectRowAction];
            [collectionView reloadData];
        }
    }
}

#pragma mark - UICollectionView设置Cell之间间距
// 定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cateWidth = (SCREENWIDTH/7.0)-0.3;
    return (CGSize){cateWidth, 44.0};
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    //NSLog(@"x=%f,y=%f",point.x,point.y);
    if (_showBut.isSelected == NO) {
        NSInteger theRow = _selectRow-1;
        if (theRow<0) {
            theRow = 0;
        }
        point.y = theRow * 44.0;
        scrollView.contentOffset = point;
    }
}

@end
