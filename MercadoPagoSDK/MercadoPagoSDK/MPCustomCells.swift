//
//  CellProtocol.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/6/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

import Foundation

@objc open class MPCustomCells : NSObject {
    open let cell: UITableViewCell
    open let inflator: MPCustomInflator
    
    public init (cell: UITableViewCell, inflator: MPCustomInflator){
        self.cell = cell
        self.inflator = inflator
    }
}
