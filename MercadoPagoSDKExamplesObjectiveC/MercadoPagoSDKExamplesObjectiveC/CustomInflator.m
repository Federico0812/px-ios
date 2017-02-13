//
//  CustomInflator.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import "CustomInflator.h"
#import "CustomTableViewCell.h"
@import MercadoPagoSDK;

@implementation CustomInflator

UINib *customCellNib = nil;
PaymentData *data;


-(void)invokeCallback{

    
}


-(void)fillCellWithCell:(UITableViewCell *)cell paymentData:(PaymentData *)paymentData{
    CustomTableViewCell *currentCell = (CustomTableViewCell *)cell;
    currentCell.label.text = @"1562663448";
    data = paymentData;
    [currentCell.button addTarget:self action:@selector(invokeCallback) forControlEvents:UIControlEventTouchUpInside];
}


-(UINib *)getNib {
    return [UINib nibWithNibName:@"CustomTableViewCell" bundle: [NSBundle mainBundle]];
}

-(CGFloat)getHeigth {
    return (CGFloat)180;
}


@end
