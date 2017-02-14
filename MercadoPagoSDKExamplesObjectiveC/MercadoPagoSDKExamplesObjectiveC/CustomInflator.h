//
//  CustomInflator.h
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 2/8/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MercadoPagoSDK;

#define SWIFT_SUBCLASS __attribute__((objc_subclassing_restricted))

SWIFT_SUBCLASS
@interface CustomInflator : NSObject<MPCustomInflator>



@end
