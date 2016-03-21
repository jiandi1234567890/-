//
//  DrawLine.m
//  圆形时钟
//
//  Created by 张海禄 on 16/3/21.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

//系统自动调用drawrect方法，视图显示在屏幕上时调用，且只调用一次
-(void)drawRect:(CGRect)rect
{


    [self drawline];
}

-(void)drawline
{     //1获得图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
     //2绘制图形
    CGContextSetLineWidth(context, 2);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextMoveToPoint(context, 20, 20);
    CGContextAddLineToPoint(context, 200, 200);
    

    //3显示到view上
    
    
    CGContextStrokePath(context);
}

@end
