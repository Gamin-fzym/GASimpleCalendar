//
//  MCDatePickerView.m
//  MFCDatePackerView
//
//  Created by machao on 2017/5/23.
//  Copyright © 2017年 machao. All rights reserved.
//

static float ToolbarH  = 45;
static float PickerViewH  = 250;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MCDatePickerView.h"
#import "CommonHeader.h"
@interface MCDatePickerView() <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong) UIPickerView *datePickerView;
@property (nonatomic ,strong) UIToolbar *toolBar;

@property (nonatomic ,strong) NSMutableArray *month;
@property (nonatomic ,strong) NSMutableArray *year;
@property (nonatomic ,strong) NSMutableArray *day;

@property (nonatomic ,assign) NSInteger selectYearRow;
@property (nonatomic ,assign) NSInteger selectMonthRow;
@property (nonatomic ,assign) NSInteger selectaDayRow;

@property (nonatomic ,copy) NSString * defultDateStr;

@property (nonatomic, assign) CGFloat toolViewY;//self的Y值
@property (nonatomic, assign ) XMGStyleType type;
@end

@implementation MCDatePickerView

- (instancetype)initWithFrame:(CGRect)frame type:(XMGStyleType)type WithDafultDateStr:(NSString *)defultDateStr{
    self.type = type;
    self.defultDateStr = defultDateStr;
    return  [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
    }
    return self;
}

#pragma mark - Delegate
 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.type == XMGStyleTypeYear) {
        return 1;
    } else if (self.type == XMGStyleTypeYearAndMonth) {
        return 2;
    }
    return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectYearRow  = row;
        if (self.type == XMGStyleTypeYearAndMonthDay) {
            [self updateDayArr];
        }
    }
    else if (component == 1)
    {
        self.selectMonthRow = row;
        if (self.type == XMGStyleTypeYearAndMonthDay) {
            [self updateDayArr];
        }
    } else {
        self.selectaDayRow = row;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return component == 0 ? self.year.count : self.month.count;
    if (component == 0)
    {
        return self.year.count;
    }
    else if (component == 1)
    {
        return self.month.count;
    } else {
        return self.day.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%@年",self.year[row]];
    }
    else if (component == 1)
    {
        return [NSString stringWithFormat:@"%@月",self.month[row]];
    } else {
        return [NSString stringWithFormat:@"%@日",self.day[row]];
    }
}

/**
    界面设置
 */
- (void)setupView
{
    [self addSubview:self.toolBar];
    
    UIPickerView *datePickerView = [[UIPickerView alloc] init];
    datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Fit(ToolbarH), SCREEN_W, PickerViewH)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.delegate   = self;
    datePickerView.dataSource = self;
    self.datePickerView = datePickerView;
    [self addSubview:datePickerView];
    
    self.toolViewY = SCREEN_H - (Fit(ToolbarH) + PickerViewH);
    self.frame     = CGRectMake(0, SCREEN_H, SCREEN_W, (Fit(ToolbarH) + PickerViewH));
    
    [self setCurrentDate];
}

/**
    设置默认时间->当前年月
 */
- (void)setCurrentDate
{
    NSString *currentDate = [NSString string];
    if (!self.defultDateStr.length || [self.defultDateStr isEqualToString:@"请选择"]) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        currentDate = [formatter stringFromDate:date];
    }else{
        currentDate = self.defultDateStr;
    }
    if (self.type == XMGStyleTypeYearAndMonth) {
        int year  = [[currentDate componentsSeparatedByString:@"-"][0] intValue];
        int month = [[currentDate componentsSeparatedByString:@"-"][1] intValue];
        NSInteger currentRow = year - [self.year[0] integerValue];
        [self.datePickerView selectRow:currentRow inComponent:0 animated:NO];
        [self.datePickerView selectRow:month-1 inComponent:1 animated:NO];
        self.selectYearRow = currentRow;
        self.selectMonthRow = month-1;
    } else if (self.type == XMGStyleTypeYearAndMonthDay) {
        int year  = [[currentDate componentsSeparatedByString:@"-"][0] intValue];
        int month = [[currentDate componentsSeparatedByString:@"-"][1] intValue];
        int day = [[currentDate componentsSeparatedByString:@"-"][2] intValue];
        NSInteger currentRow = year - [self.year[0] integerValue];
        [self.datePickerView selectRow:currentRow inComponent:0 animated:NO];
        [self.datePickerView selectRow:month-1 inComponent:1 animated:NO];
        [self.datePickerView selectRow:day-1 inComponent:2 animated:NO];
        self.selectYearRow = currentRow;
        self.selectMonthRow = month-1;
        self.selectaDayRow = day - 1;
    }else{
        int year  = [[currentDate componentsSeparatedByString:@"-"][0] intValue];
        NSInteger currentRow = year - [self.year[0] integerValue];
        [self.datePickerView selectRow:currentRow inComponent:0 animated:NO];
        self.selectYearRow = currentRow;
    }

}

/**
    工具栏
 */
- (UIToolbar *)toolBar
{
    if (!_toolBar)
    {

        _toolBar = [[UIToolbar alloc] init];
        _toolBar.frame = CGRectMake(0, 0, SCREEN_W, Fit(ToolbarH));
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"   取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确认   " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
        _toolBar.backgroundColor = HexColor(@"#F7F9FF");
        _toolBar.items = @[cancelItem, flexSpace, doneItem];
        
        [cancelItem setTintColor:HexColor(@"#03A9F4")];
        [doneItem setTintColor:HexColor(@"#03A9F4")];

        
        UIView * string = [[UIView alloc] initWithFrame:CGRectMake(0, Fit(44), SCREENWIDTH, 1)];
        string.backgroundColor = HexColor(@"#EEEEEE");
        [_toolBar addSubview:string];
    }
    return _toolBar;
}

/**
    确定
 */
- (void)doneClick
{
    NSString *year  = self.year[self.selectYearRow];
    NSString *month = self.month[self.selectMonthRow];
    NSString *day = self.day[self.selectaDayRow];
    
    if (month.length == 1)
    {
        month = [NSString stringWithFormat:@"0%@",month];
    }
    
    if (day.length == 1)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    
    NSString *resultDate = [NSString stringWithFormat:@"%@-%@",year,month];
    if (self.type == XMGStyleTypeYearAndMonthDay) {
        resultDate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    } else if (self.type == XMGStyleTypeYear) {
        resultDate = [NSString stringWithFormat:@"%@",year];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDateResult:)])
    {
        [self.delegate didSelectDateResult:resultDate];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDateResult:ViewTag:)])
    {
        [self.delegate didSelectDateResult:resultDate ViewTag:self.tag];
    }
    
    [self remove];
}


/**
    移除PickerView
 */
- (void)remove
{
    
    [UIView animateWithDuration:0.35 animations:^
     {
         self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, PickerViewH + Fit(ToolbarH));
         
     } completion:^(BOOL finished)
     {
         for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews])
         {
             if (view.tag == 1001)
             {
                 [view removeFromSuperview];
             }
         }
     }];
    
}

/**
    显示PickerView
 */
- (void)show
{
    UIView *screenView         = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    screenView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                 green:0/255.0
                                                  blue:0/255.0
                                                 alpha:0.5];
    screenView.tag             = 1001;
    [screenView addSubview:self];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    
    [screenView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview: screenView];
    
    [UIView animateWithDuration:0.35 animations:^
     {
         screenView.alpha = 1.0;
         self.frame = CGRectMake(0, self.toolViewY, SCREEN_W, PickerViewH + Fit(ToolbarH));
         
     } completion:^(BOOL finished)
     {
         
     }];
}

/**
    获取年份数据
 */
- (NSMutableArray *)year
{
    if (!_year)
    {
        _year = [NSMutableArray array];
        
        for (int i = 1900; i < 2100; i++)
        {
            NSString *yearStr = [NSString stringWithFormat:@"%d",i];
            [_year addObject:yearStr];
        }
        
    }
    return _year;
}

/**
    获取月份数据
 */
- (NSMutableArray *)month
{
    if (!_month)
    {
        _month = [NSMutableArray array];
        
        for (int i = 1; i < 13; i++)
        {
            NSString *monthStr = [NSString stringWithFormat:@"%d",i];
            [_month addObject:monthStr];
        }
    }
    
    return _month;
}

/**
 获取日数据
 */
- (NSMutableArray *)day
{
    if (!_day)
    {
        _day = [NSMutableArray array];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *dateSelectMonth = [NSDate date]; //[df dateFromString:[NSString stringWithFormat:@"%ld-%02ld-01 13:10:15", iYear, iMonth]];
        
        NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateSelectMonth];
        NSInteger dayCountOfThisMonth = daysInLastMonth.length;
        
        for (int i = 1; i <= dayCountOfThisMonth; i++)
        {
            NSString *dayStr = [NSString stringWithFormat:@"%d",i];
            [_day addObject:dayStr];
        }
    }
    
    return _day;
}

- (void)updateDayArr
{
    [_day removeAllObjects];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [NSString stringWithFormat:@"%ld-%02ld-01 13:10:15", self.selectYearRow  + 1900, self.selectMonthRow + 1];
    NSDate *dateSelectMonth = [df dateFromString:dateStr];
    
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateSelectMonth];
    NSInteger dayCountOfThisMonth = daysInLastMonth.length;
    
    NSLog(@"%ld-%ld = %ld天", self.selectYearRow + 1 - 1900, self.selectMonthRow + 1, dayCountOfThisMonth);
    
    for (int i = 1; i <= dayCountOfThisMonth; i++)
    {
        NSString *dayStr = [NSString stringWithFormat:@"%d",i];
        [_day addObject:dayStr];
    }
    
    [self.datePickerView reloadComponent:2];
    NSInteger iSelectRow = 0;
    if (self.selectaDayRow < dayCountOfThisMonth) {
        iSelectRow = self.selectaDayRow;
    }
    self.selectaDayRow = iSelectRow;
    
    [self.datePickerView selectRow:iSelectRow inComponent:2 animated:YES];
}


@end
