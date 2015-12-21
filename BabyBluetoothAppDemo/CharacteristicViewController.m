//
//  CharacteristicViewController.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/7.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "CharacteristicViewController.h"
#import "SVProgressHUD.h"

@interface CharacteristicViewController (){
    IBOutlet UIButton *youmen_100;
    IBOutlet UIButton *youmen_0;
    IBOutlet UIButton *fangxiang_0;
    IBOutlet UIButton *fangxiang_100;
    
    IBOutlet UIButton *fuyi_0;
    IBOutlet UIButton *fuyi_100;
    IBOutlet UIButton *shengjiang_100;
    IBOutlet UIButton *shengjiang_0;

    

    NSTimer *timer;
    int youmen;
    int fangxiang;
    int fuyi;
    int shengjiang;
    
    NSInteger nowTag;
    IBOutlet UILabel *youmenLabel;
    IBOutlet UILabel *fangxiangLabel;
    IBOutlet UILabel *fuyiLabel;
    IBOutlet UILabel *shengjiangLabel;
}

@end

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define navHeight ( isIOS7 ? 64 : 44)  //导航栏高度
#define channelOnCharacteristicView @"CharacteristicView"


@implementation CharacteristicViewController
// 左边油门（上下运动）/方向 （水平旋转） ，右边副翼（左右俯冲）/升降 （前后俯冲）
//#define YOUMEN 2
//#define FANGXIANG 3
//#define FUYI 4
//#define SHENGJIANG 5
- (void)viewDidLoad {
    [super viewDidLoad];
    youmen = 0;
    fangxiang = 50;
    fuyi = 50;
    shengjiang = 50;
//    start.tag = 1;
////    top.tag = 1;
//    bottom.tag = 2;
//    left.tag = 5;
//    right.tag = 4;
//    stop.tag = 3;
//    up.tag = 6;
//    down.tag = 7;
    
    youmen_100.tag = 1;
    youmen_0.tag = 2;
    fangxiang_100.tag = 3;
    fangxiang_0.tag = 4;
    fuyi_100.tag = 5;
    fuyi_0.tag = 6;
    shengjiang_100.tag = 7;
    shengjiang_0.tag = 8;
    
    nowTag = 0;
    
    timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(s) userInfo:nil repeats:YES];
   
   [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    NSTimer *signalTimer =[NSTimer timerWithTimeInterval:0.4 target:self selector:@selector(signal) userInfo:nil repeats:YES];
    [signalTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:signalTimer forMode:NSDefaultRunLoopMode];
    [self sendData:@"a" Value:youmen];
    [self sendData:@"b" Value:fangxiang];
    [self sendData:@"c" Value:fuyi];
    [self sendData:@"d" Value:shengjiang];
}
-(void)signal
{
    [self sendData:@"s" Value:1]; //心跳信号
}
-(IBAction)youmen_high:(id)sender
{
    youmen = 100;
    [self sendData:@"a" Value:youmen];
}
-(IBAction)youmen_low:(id)sender
{
    youmen = 0;
    [self sendData:@"a" Value:youmen];
}
-(IBAction)lock:(id)sender
{
    youmen = 0;
    fangxiang = 0;
    [self sendData:@"a" Value:youmen];
    [self sendData:@"b" Value:fangxiang];
}
-(IBAction)unlock:(id)sender
{
    youmen = 0;
    fangxiang = 100;
    [self sendData:@"a" Value:youmen];
    [self sendData:@"b" Value:fangxiang];
}
-(IBAction)reset:(id)sender
{
    youmen = 0;
    fangxiang = 50;
    fuyi = 50;
    shengjiang = 50;
    [self sendData:@"a" Value:youmen];
    [self sendData:@"b" Value:fangxiang];
    [self sendData:@"c" Value:fuyi];
    [self sendData:@"d" Value:shengjiang];
}
-(IBAction)up:(UIButton *)sender
{
    [timer invalidate];
    timer = nil;
    nowTag = 0;
}

-(IBAction)send:(UIButton *)sender
{
    
    nowTag = sender.tag;
    
    timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(s) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

-(void)s
{
//    [downtimer invalidate];
    
    
    switch (nowTag) {
        case 1:
            youmen +=1;
            if(youmen >100){
                youmen = 100;
            }
            [self sendData:@"a" Value:youmen];
            break;
        case 2:
            youmen -=1;
            if(youmen<0){
                youmen = 0;
            }
            [self sendData:@"a" Value:youmen];
            break;
        case 3:
            fangxiang +=1;
            if(fangxiang >100){
                fangxiang = 100;
            }
            [self sendData:@"b" Value:fangxiang];
            break;
        case 4:
            fangxiang -=1;
            if(fangxiang<0){
                fangxiang = 0;
            }
            [self sendData:@"b" Value:fangxiang];
            break;
        case 5:
            fuyi +=1;
            if(fuyi >100){
                fuyi = 100;
            }
            [self sendData:@"c" Value:fuyi];
            break;
        case 6:
            fuyi -=1;
            if(fuyi<0){
                fuyi = 0;
            }
            [self sendData:@"c" Value:fuyi];
            break;
        case 7:
            shengjiang +=1;
            if(shengjiang >100){
                shengjiang = 100;
            }
            [self sendData:@"d" Value:shengjiang];
            break;
        case 8:
            shengjiang -=1;
            if(shengjiang<0){
                shengjiang = 0;
            }
            [self sendData:@"d" Value:shengjiang];
            break;
        default:
            break;
    }
    
    youmenLabel.text = [NSString stringWithFormat:@"%d", youmen];
    fangxiangLabel.text = [NSString stringWithFormat:@"%d", fangxiang];
    fuyiLabel.text = [NSString stringWithFormat:@"%d", fuyi];
    shengjiangLabel.text = [NSString stringWithFormat:@"%d", shengjiang];
   
}

-(void)sendData:(NSString *)beginChar Value:(int)value
{
    NSString *key = [NSString stringWithFormat:@"%@%d\n",beginChar,value];
    NSData *data = [key dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"data:%@",data);
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}
-(void)babyDelegate{

    __weak typeof(self)weakSelf = self;
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [weakSelf insertReadValues:characteristics];
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
//            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            [weakSelf insertDescriptor:d];
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
//                NSString *valueStr = [[NSString alloc]initWithData:descriptor.value encoding:NSUTF8StringEncoding];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",descriptor.value];
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
         NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    //设置通知状态改变的block
    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    
    
}

//插入描述
-(void)insertDescriptor:(CBDescriptor *)descriptor{
    [self->descriptors addObject:descriptor];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:self->descriptors.count-1 inSection:2];
    [indexPahts addObject:indexPaht];
    [self.tableView insertRowsAtIndexPaths:indexPahts withRowAnimation:UITableViewRowAnimationAutomatic];
}
//插入读取的值
-(void)insertReadValues:(CBCharacteristic *)characteristics{
    [self->readValueArray addObject:[NSString stringWithFormat:@"%@",characteristics.value]];
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self->readValueArray.count-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self->readValueArray.count-1 inSection:0];
    [indexPaths addObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//写一个值
-(void)writeValue{
//    int i = 1;
    Byte b = 0X01;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
}
//订阅一个值
-(void)setNotifiy:(id)sender{
    
    __weak typeof(self)weakSelf = self;
    UIButton *btn = sender;
    if(self.currPeripheral.state != CBPeripheralStateConnected){
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (self.characteristic.properties & CBCharacteristicPropertyNotify ||  self.characteristic.properties & CBCharacteristicPropertyIndicate){
        
        if(self.characteristic.isNotifying){
            [baby cancelNotify:self.currPeripheral characteristic:self.characteristic];
            [btn setTitle:@"通知" forState:UIControlStateNormal];
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            [btn setTitle:@"取消通知" forState:UIControlStateNormal];
            [baby notify:self.currPeripheral
          characteristic:self.characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                NSLog(@"notify block");
//                NSLog(@"new value %@",characteristics.value);
                [self insertReadValues:characteristics];
            }];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
        return;
    }
    
}

@end
