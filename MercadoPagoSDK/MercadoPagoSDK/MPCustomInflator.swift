//
//  MPCustomInflator.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/7/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
@objc
public protocol MPCustomInflator : NSObjectProtocol {
    
    func fillCell(cell: UITableViewCell, paymentData: PaymentData)
    
    func getNib() -> UINib
    
    func getHeigth() -> CGFloat
    
    var nib: UINib {get}
}
