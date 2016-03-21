//
//  ViewController.m
//  圆形时钟
//
//  Created by 张海禄 on 16/3/21.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "ViewController.h"
#import "DrawLine.h"
#import <QuartzCore/QuartzCore.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface ViewController (){
    CALayer *seconds;
    CALayer *minute;
    CALayer *hour;
    UILabel *showtime;
    NSString *number;
}


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView   *mainview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    mainview.backgroundColor=[UIColor whiteColor];
   
    [self.view addSubview:mainview];
    
    
    //画表盘圆框
       CAShapeLayer  *layer=[CAShapeLayer layer];
        CGMutablePathRef layerpath =  CGPathCreateMutable();
        layer.lineWidth = 8.0f ;
         layer.strokeColor =[UIColor colorWithRed:0.81 green:0.89 blue:0.91 alpha:1.00].CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        CGPathAddEllipseInRect(layerpath, nil, CGRectMake(ScreenWidth/2-190/2,  ScreenHeight/3-190/2, 190, 190));
        layer.path = layerpath;
    
        CGPathRelease(layerpath);
        [mainview.layer addSublayer:layer];

    
   //表盘上的刻度数字
    for(int i=1;i<=12;i++){
        UILabel *label=[[UILabel alloc]init];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        
        int  x1   =   (ScreenWidth/2-10)   +   162/2   *   cos(2*M_PI/12*i-M_PI/2);
        int y1   =  (ScreenHeight/3-10)   +   162/2   *   sin(2*M_PI/12*i-M_PI/2);
        label.frame=CGRectMake(x1, y1, 20, 20);
        NSString *string=[NSString stringWithFormat:@"%d",i];
        label.text=string;
        [mainview addSubview:label];
    }
    

    
    
    

    //钟表背景图片
//    CALayer *clocklayer=[[CALayer layer]init];
//    clocklayer.frame=CGRectMake(0, 0, 200, 200);
//    clocklayer.position=CGPointMake(ScreenWidth/2, ScreenHeight/3);
//    clocklayer.contents=(id)[UIImage imageNamed:@"clock.png"].CGImage;
//    [mainview.layer addSublayer:clocklayer];
    
        //初始化时针
    hour=[[CALayer layer]init];
    hour.frame=CGRectMake(0, 0, 75, 5);
    hour.position=CGPointMake(ScreenWidth/2, ScreenHeight/3);
    hour.backgroundColor=[UIColor blackColor].CGColor;
    //锚点
    hour.anchorPoint=CGPointMake(0.15, 0.5);
    [mainview.layer addSublayer:hour];
    //self->hour=hour;
    
    
    //初始化分针
    minute=[[CALayer layer]init];
    minute.frame=CGRectMake(0, 0, 83, 3);
    minute.position=CGPointMake(ScreenWidth/2, ScreenHeight/3);
    minute.backgroundColor=[UIColor blackColor].CGColor;
    minute.anchorPoint=CGPointMake(0.15, 0.5);
    [mainview.layer addSublayer:minute];
    
    
    
    //初始化秒针
    
    seconds=[[CALayer layer]init];
    seconds.frame=CGRectMake(0, 0, 93, 2);
    seconds.position=CGPointMake(ScreenWidth/2, ScreenHeight/3);
    seconds.backgroundColor=[UIColor redColor].CGColor;
    seconds.anchorPoint=CGPointMake(0.15, 0.5);
    [mainview.layer addSublayer:seconds];
    
    
    
    //label 显示本地时间
    showtime=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, ScreenHeight/3+150, 200, 40)];
    showtime.backgroundColor=[UIColor whiteColor];
    [mainview addSubview:showtime];

    
    //用displaylink的方法显示当前时间
    CADisplayLink *link=[CADisplayLink displayLinkWithTarget:self selector:@selector(changetime)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
   // 用定时器显示时间
//    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:0.999f target:self selector:@selector(changetime) userInfo:nil repeats:YES];
    
    
}




-(void) changetime
{

    //获得系统时间
    NSDate  *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hh"];
    NSInteger  timehour=[[dateformatter stringFromDate:senddate]integerValue];
   // NSLog(@"%ld",timehour);
    [dateformatter setDateFormat:@"mm"];
    NSInteger  timeminute=[[dateformatter stringFromDate:senddate]integerValue];
    //NSLog(@"%ld",timeminute);
    [dateformatter setDateFormat:@"ss"];
    NSInteger  timeseconds=[[dateformatter stringFromDate:senddate]integerValue];
   // NSLog(@"%ld",timeseconds);
    //获得本地时间的上午、下午字段
    [dateformatter setDateFormat:@"HH:mm:a"];
     NSString *ampm = [[[dateformatter stringFromDate:[NSDate date]] componentsSeparatedByString:@":"] objectAtIndex:2];
    
    //根据时间来显示时针等指向，由于ios 坐标系的问题，12点是270°，3点是360°，要对时间做一些相应的处理
    float ss=2*M_PI/60*(timeseconds-15);
    float mm=2*M_PI/60*(timeminute-15)+2*M_PI/60*timeseconds/60;
    float hh=2*M_PI/12*(timehour+9)+2*M_PI/12*timeminute/60+2*M_PI/12/60*timeseconds/60;
    
    
    seconds.AffineTransform = CGAffineTransformMakeRotation(ss);
    
   
    minute.affineTransform = CGAffineTransformMakeRotation(mm);
    

    hour.affineTransform = CGAffineTransformMakeRotation(hh);
    NSString *labeltime=[NSString stringWithFormat:@"时间        %ld:%ld:%ld   %@",(long)timehour,(long)timeminute,(long)timeseconds,ampm];
    
    showtime.text=labeltime;
    
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
