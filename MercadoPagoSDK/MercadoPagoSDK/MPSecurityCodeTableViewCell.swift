//
//  MPSecurityCodeTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 30/12/14.
//  Copyright (c) 2014 com.mercadopago. All rights reserved.
//

import Foundation
import UIKit

public class MPSecurityCodeTableViewCell : ErrorTableViewCell {
    @IBOutlet weak private var securityCodeLabel: MPLabel!
    @IBOutlet weak private var securityCodeInfoLabel: MPLabel!
    @IBOutlet weak public var securityCodeTextField: MPTextField!
    @IBOutlet weak private var securityCodeImageView: UIImageView!
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
		self.securityCodeLabel.text = "security_code".localized
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getSecurityCode() -> String! {
        return self.securityCodeTextField.text
    }
    
    public func fillWithPaymentMethod(pm : PaymentMethod) {
        self.securityCodeImageView.image = MercadoPago.getImage("imgTc_" + pm._id)
        if pm._id == "amex" {
			var amexCvvLength = 4
			if pm.settings != nil && pm.settings.count > 0 {
				amexCvvLength = pm.settings[0].securityCode!.length
			}
			
            self.securityCodeInfoLabel.text = ("cod_seg_desc_amex".localized as NSString).stringByReplacingOccurrencesOfString("%1$s", withString: "\(amexCvvLength)")
        } else {
			var cvvLength = 3
			if pm.settings != nil && pm.settings.count > 0 {
				cvvLength = pm.settings[0].securityCode!.length
			}
			
            self.securityCodeInfoLabel.text = ("cod_seg_desc".localized as NSString).stringByReplacingOccurrencesOfString("%1$s", withString: "\(cvvLength)")
        }
        
    }
    
}