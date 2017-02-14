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

@synthesize delegate = _delegate;
@synthesize callbackPaymentData = _callbackPaymentData;
@synthesize nib;

-(void)invokeCallback {
    
    [self.delegate invokeCallbackWithPaymentDataWithRowCallback:^(PaymentData *paymentData) {
        self.callbackPaymentData(paymentData);
    }];
}


-(void)fillCellWithCell:(UITableViewCell *)cell {
    CustomTableViewCell *currentCell = (CustomTableViewCell *)cell;
    currentCell.label.text = @"1562663448";
    [currentCell.button addTarget:self action:@selector(invokeCallback) forControlEvents:UIControlEventTouchUpInside];
}


-(UINib *)getNib {
    return [UINib nibWithNibName:@"CustomTableViewCell" bundle: [NSBundle mainBundle]];
}

-(CGFloat)getHeigth {
    return (CGFloat)180;
}

-(void) setDelegate: (CheckoutViewController * ) delegate {
    _delegate = delegate;
}
-(void) setCallbackPaymentData:(void (^)(PaymentData * _Nonnull))callbackPaymentData{
    _callbackPaymentData = callbackPaymentData;
}


@end
