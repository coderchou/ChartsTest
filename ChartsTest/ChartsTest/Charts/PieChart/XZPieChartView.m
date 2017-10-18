//
//  XZPieChartView.m
//  YiQIWo
//
//  Created by 周灿华 on 2017/10/16.
//  Copyright © 2017年 zhanghongwei. All rights reserved.
//

#import "XZPieChartView.h"

#define BgColor [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1]


@implementation XZPieChartViewConfig

+ (instancetype)defaultConfig {
    XZPieChartViewConfig *defaultConfig = [[XZPieChartViewConfig alloc] init];
    defaultConfig.backgroundColor = [UIColor whiteColor];
    defaultConfig.extraOffsets = UIEdgeInsetsMake(20, 20, 20, 25);
    defaultConfig.usePercentValuesEnabled = YES;
    defaultConfig.dragDecelerationEnabled = YES;
    defaultConfig.drawSliceTextEnabled = NO;
    
    defaultConfig.drawHoleEnabled = NO;
    defaultConfig.holeRadiusPercent = 0.8;
    defaultConfig.holeColor = [UIColor clearColor];
    defaultConfig.transparentCircleRadiusPercent = 0.52;
    defaultConfig.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];
    defaultConfig.centerText = @"";
    
    defaultConfig.descriptionFont = [UIFont systemFontOfSize:15];
    defaultConfig.descriptionTextColor = [UIColor grayColor];
    defaultConfig.descriptionText = @"";
    
    defaultConfig.maxSizePercent = 0.95;
    defaultConfig.formToTextSpace = 5;
    defaultConfig.legendFont = [UIFont systemFontOfSize:12];
    defaultConfig.legendTextColor = [UIColor grayColor];
    defaultConfig.legendPosition = ChartLegendPositionLeftOfChartCenter;
    defaultConfig.legendForm = ChartLegendFormSquare;
    defaultConfig.legendFormSize = 10;
    
    defaultConfig.sliceSpace = 0;
    defaultConfig.selectionShift = 8;
    defaultConfig.xValuePosition = PieChartValuePositionInsideSlice;
    defaultConfig.yValuePosition = PieChartValuePositionOutsideSlice;
    
    defaultConfig.valueLinePart1OffsetPercentage = 0.85;
    defaultConfig.valueLinePart1Length = 0.5;
    defaultConfig.valueLinePart2Length = 0.4;
    defaultConfig.valueLineWidth = 1;
    defaultConfig.valueLineColor = [UIColor brownColor];
    
    return defaultConfig;
}

@end


@interface XZPieChartView ()<ChartViewDelegate>

@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) PieChartData *data;
@property (nonatomic, strong) XZPieChartViewConfig *config;
@property (nonatomic, copy)   XZPieChartViewConfigBlock configBlock;
/** 饼图颜色数组 */
@property (nonatomic, strong) NSArray<UIColor *> *pieColors;


@end

@implementation XZPieChartView

- (instancetype)initWithFrame:(CGRect)frame configBlock:(XZPieChartViewConfigBlock)configBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BgColor;
        self.config = [XZPieChartViewConfig defaultConfig];
        self.configBlock = configBlock;
        self.configBlock(self.config);
        
        //创建饼状图
        self.pieChartView = [[PieChartView alloc] init];
        self.pieChartView.backgroundColor = self.config.backgroundColor;
        [self addSubview:self.pieChartView];
        [self.pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(self);
        }];
        
        //基本样式
        // 饼状图距离边缘的间隙
        [self.pieChartView setExtraOffsetsWithLeft:self.config.extraOffsets.left top:self.config.extraOffsets.top right:self.config.extraOffsets.right bottom:self.config.extraOffsets.bottom];
        //是否根据所提供的数据, 将显示数据转换为百分比格式
        self.pieChartView.usePercentValuesEnabled = self.config.usePercentValuesEnabled;
        //拖拽饼状图后是否有惯性效果
        self.pieChartView.dragDecelerationEnabled = self.config.dragDecelerationEnabled;
        //是否显示区块文本
        self.pieChartView.drawSliceTextEnabled = self.config.drawSliceTextEnabled;
        
        
        //空心饼状图样式 如果不需要空心样式的饼状图, 可以将饼状图的drawHoleEnabled赋值为NO, 将中间的文本去掉即可, 代码如下:
        //饼状图是否是空心
        self.pieChartView.drawHoleEnabled = self.config.drawHoleEnabled;
        //空心半径占比
        self.pieChartView.holeRadiusPercent = self.config.holeRadiusPercent;
        //空心颜色
        self.pieChartView.holeColor = self.config.holeColor;
        //半透明空心半径占比
        self.pieChartView.transparentCircleRadiusPercent = self.config.transparentCircleRadiusPercent;
        //半透明空心的颜色
        self.pieChartView.transparentCircleColor = self.config.transparentCircleColor;
        
        //饼状图中间描述
        if (self.pieChartView.isDrawHoleEnabled == YES) {
            //是否显示中间文字
            self.pieChartView.drawCenterTextEnabled = YES;
            //普通文本
            //        self.pieChartView.centerText = @"饼状图";//中间文字
            //富文本
            NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:self.config.centerText];
            [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                        NSForegroundColorAttributeName: [UIColor orangeColor]}
                                range:NSMakeRange(0, centerText.length)];
            self.pieChartView.centerAttributedText = centerText;
        }else{
            
            // drawHoleEnabled 为NO时 走这个方法
        }
        self.pieChartView.delegate = self;
        
        //饼状图描述
        self.pieChartView.descriptionFont = self.config.descriptionFont;
        self.pieChartView.descriptionTextColor = self.config.descriptionTextColor;
        self.pieChartView.descriptionText = self.config.descriptionText;
        
        
        //饼状图图例
        //图例在饼状图中的大小占比, 这会影响图例的宽高
        self.pieChartView.legend.maxSizePercent = self.config.maxSizePercent;
        //文本间隔
        self.pieChartView.legend.formToTextSpace = self.config.formToTextSpace;
        //字体大小
        self.pieChartView.legend.font = self.config.legendFont;
        //字体颜色
        self.pieChartView.legend.textColor = self.config.legendTextColor;
        //图例在饼状图中的位置
        self.pieChartView.legend.position = self.config.legendPosition;
        //图示样式: 方形、线条、圆形
        self.pieChartView.legend.form = self.config.legendForm;
        //图示大小
        self.pieChartView.legend.formSize = self.config.legendFormSize;
        
        
        //为饼状图提供数据
        self.data = [self setDataWithTitles:self.config.titles values:self.config.values];
        self.pieChartView.data = self.data;
        //设置动画效果
        [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
    }
    return self;
    
}

//刷新
- (void)updateData{
    //为饼状图提供数据
    self.data = [self setDataWithTitles:self.config.titles values:self.config.values];
    self.pieChartView.data = self.data;
    //设置动画效果
    [self.pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
}

- (PieChartData *)setDataWithTitles:(NSArray *)titles values:(NSArray *)values {
    NSInteger count = values.count;//饼状图总共有几块组成
    //每个区块的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        //        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
        double value = [values[i] doubleValue];
        PieChartDataEntry *entry = [[PieChartDataEntry alloc] initWithValue:value label:titles[i]];
        [yVals addObject:entry];
    }
    
    //dataSet
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:yVals label:@""];
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        if (i < self.pieColors.count) {
            [colors addObject:self.pieColors[i]];
        }else {
            [colors addObject:kRandomColor];
        }
    }
    
    //区块颜色
    dataSet.colors = colors;
    //相邻区块之间的间距
    dataSet.sliceSpace = self.config.sliceSpace;
    //选中区块时, 放大的半径
    dataSet.selectionShift = self.config.selectionShift;
    
    //PieChartValuePositionInsideSlice 数据显示在饼图内部  PieChartValuePositionOutsideSlice外部,外部条件下有折线
    //名称位置
    dataSet.xValuePosition = self.config.xValuePosition;
    //数据位置
    dataSet.yValuePosition = self.config.yValuePosition;
    
    //数据与区块之间的用于指示的折线样式
    //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1OffsetPercentage = self.config.valueLinePart1OffsetPercentage;
    //折线中第一段长度占比
    dataSet.valueLinePart1Length = self.config.valueLinePart1Length;
    //折线中第二段长度最大占比
    dataSet.valueLinePart2Length = self.config.valueLinePart2Length;
    //折线的粗细
    dataSet.valueLineWidth = self.config.valueLineWidth;
    //折线颜色
    dataSet.valueLineColor = self.config.valueLineColor;
    
    
    //对数据样式进行操作
    PieChartData *data = [[PieChartData alloc]  initWithDataSet:dataSet];
    
    //如果前面已设置将数据转化为百分比形式，那么这么设置数据格式为百分数形式NSNumberFormatterPercentStyle
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    formatter.maximumFractionDigits = 2;//小数位数
    formatter.multiplier = @1.f;
    
    ChartDefaultValueFormatter  *forma =
    [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]
    ;
    [data setValueFormatter:forma];//设置显示数据格式
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    
    return data;
}

- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight{
    
    
    NSLog(@"%f",highlight.y);
}


#pragma mark - 懒加载
- (NSArray<UIColor *> *)pieColors {
    if (_pieColors == nil) {
        _pieColors = @[
                    RGB(253, 153,  41),     //1号
                    RGB(253, 100,  67),     //2号
                    RGB(250,  31,  49),     //3号
                    RGB(192,  46, 144),     //4号
                    RGB(  0, 182, 194),     //8号
                    RGB(248, 252,  59),     //11号
                    RGB(135,  26, 139),     //5号
                    RGB( 96, 208,  93),     //10号
                    RGB( 90,  57, 152),     //6号
                    RGB(  0, 183, 117),     //9号
                    RGB( 62, 104, 182)      //7号
                    ];
    }
    return _pieColors;
}

@end
