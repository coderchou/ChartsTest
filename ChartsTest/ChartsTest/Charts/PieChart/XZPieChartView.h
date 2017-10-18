//
//  XZPieChartView.h
//  YiQIWo
//
//  Created by 周灿华 on 2017/10/16.
//  Copyright © 2017年 zhanghongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartsTest-Bridging-Header.h"

@interface XZPieChartViewConfig : NSObject

+ (instancetype)defaultConfig;

/** 背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 饼状图距离边缘的间隙 */
@property (nonatomic, assign) UIEdgeInsets extraOffsets;
/** 是否根据所提供的数据, 将显示数据转换为百分比格式,,默认YES */
@property (nonatomic, assign) BOOL usePercentValuesEnabled;
/** 拖拽饼状图后是否有惯性效果,默认YES */
@property (nonatomic, assign) BOOL dragDecelerationEnabled;
/** 是否显示区块文本,默认NO */
@property (nonatomic, assign) BOOL drawSliceTextEnabled;


/** 饼状图是否是空心,默认NO */
@property (nonatomic, assign) BOOL drawHoleEnabled;
/** 空心半径占比,默认0.8 */
@property (nonatomic, assign) CGFloat holeRadiusPercent;
/** 空心颜色 */
@property (nonatomic, strong) UIColor *holeColor;
/** 半透明空心半径占比 */
@property (nonatomic, assign) CGFloat transparentCircleRadiusPercent;
/** 半透明空心的颜色 */
@property (nonatomic, strong) UIColor *transparentCircleColor;
/** 饼状图中间描述 */
@property (nonatomic, strong) NSString *centerText;


/** 饼状图描述font */
@property (nonatomic, strong) UIFont *descriptionFont;
/** 饼状图描述color */
@property (nonatomic, strong) UIColor *descriptionTextColor;
/** 饼状图描述text */
@property (nonatomic, strong) NSString *descriptionText;



/** 图例在饼状图中的大小占比, 这会影响图例的宽高,0 ~ 1 */
@property (nonatomic, assign) CGFloat maxSizePercent;
/** 文本间隔 */
@property (nonatomic, assign) CGFloat formToTextSpace;
/** 文本间隔 */
@property (nonatomic, strong) UIFont *legendFont;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *legendTextColor;
/** 图例在饼状图中的位置 */
@property (nonatomic, assign) ChartLegendPosition legendPosition;
/** 图示样式: 方形、线条、圆形 */
@property (nonatomic, assign) ChartLegendForm legendForm;
/** 图示大小 */
@property (nonatomic, assign) CGFloat legendFormSize;


/** 相邻区块之间的间距 */
@property (nonatomic, assign) CGFloat sliceSpace;
/** 选中区块时, 放大的半径 */
@property (nonatomic, assign) CGFloat selectionShift;
/** 名称位置 */
@property (nonatomic, assign) PieChartValuePosition xValuePosition;
/** 名称位置 */
@property (nonatomic, assign) PieChartValuePosition yValuePosition;


/** 折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远 */
@property (nonatomic, assign) CGFloat valueLinePart1OffsetPercentage;
/** 折线中第一段长度占比 */
@property (nonatomic, assign) CGFloat valueLinePart1Length;
/** 折线中第二段长度最大占比 */
@property (nonatomic, assign) CGFloat valueLinePart2Length;
/** 折线的粗细 */
@property (nonatomic, assign) CGFloat valueLineWidth;
/** 折线颜色 */
@property (nonatomic, strong) UIColor *valueLineColor;


/** 标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 值数组 */
@property (nonatomic, strong) NSArray *values;


@end




typedef void(^XZPieChartViewConfigBlock)(XZPieChartViewConfig *config);

@interface XZPieChartView : UIView


/**
 初始化pieChart

 @param frame 尺寸
 @param configBlock 初始化配置
 @return pieChart实例
 */
- (instancetype)initWithFrame:(CGRect)frame configBlock:(XZPieChartViewConfigBlock)configBlock;


/**
 刷新数据
 */
- (void)updateData;

@end
