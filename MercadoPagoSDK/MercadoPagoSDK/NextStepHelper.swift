//
//  NextStepHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 2/3/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

extension MercadoPagoCheckoutViewModel {
    
    func needSearch() -> Bool {
        return search == nil
    }
    func isPaymentTypeSelected() -> Bool {
        
        if self.paymentData.paymentMethod != nil && (self.search != nil) && !self.paymentData.paymentMethod.isAccountMoney(){
            var paymentOptionSelected : PaymentMethodSearchItem!
            if !self.paymentData.paymentMethod.isCard() {
                if let paymentTypeId = PaymentTypeId(rawValue : paymentData.paymentMethod.paymentTypeId) {
                    paymentOptionSelected = Utils.findPaymentMethodSearchItemInGroups(self.search!, paymentMethodId: paymentData.paymentMethod._id, paymentTypeId: paymentTypeId)
                }
            } else {
                if let paymentTypeId = PaymentTypeId(rawValue : paymentData.paymentMethod.paymentTypeId) {
                    paymentOptionSelected = Utils.findPaymentMethodTypeId(self.search!, paymentTypeId: paymentTypeId)
                }
            }
            self.paymentOptionSelected = paymentOptionSelected
            return true
        }
        
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        return !selectedType.hasChildren()
    }
    func needCompleteCard() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        if selectedType.isCustomerPaymentMethod(){
            return false
        }
        if !selectedType.isCard() {
            return false
        }
        return self.cardToken == nil && self.paymentData.paymentMethod == nil
    }
    
    func showConfirm() -> Bool {
        return self.paymentData.isComplete()
    }
    
    func showCongrats() -> Bool {
        return self.payment != nil
    }
    func needGetIdentification() -> Bool {
        guard let pm = self.paymentData.paymentMethod , let option = self.paymentOptionSelected else {
            return false
        }
        guard let holder = self.cardToken?.cardholder else {
            return false
        }
        if let identification = holder.identification{
            if String.isNullOrEmpty(identification.number) && pm.isIdentificationRequired() && !option.isCustomerPaymentMethod(){
                return true
            }
        }
        return false
    
    }
    func needGetIssuer() -> Bool {
        guard let selectedType = self.paymentOptionSelected else {
            return false
        }
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if selectedType.isCustomerPaymentMethod(){
            return false
        }
        if paymentData.issuer == nil  && pm.isCard()  { 
            return true
        }
        return false
    }
    
    func needSelectCreditDebit() -> Bool {
        if self.paymentMethods != nil && self.paymentMethods?.count == 2 {//&&
            //((self.paymentMethods![0].paymentTypeId == PaymentTypeId.CREDIT_CARD && self.paymentMethods![1].paymentTypeId == PaymentTypeId.CREDIT_CARD) ||
            //    (self.paymentMethods![1].paymentTypeId == PaymentTypeId.CREDIT_CARD && self.paymentMethods![0].paymentTypeId == PaymentTypeId.CREDIT_CARD))) {
            return true
        }
        return false
    }
    
    func needChosePayerCost() -> Bool {
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        if pm.isCreditCard() && self.paymentData.payerCost == nil {
            return true
        }else{
            return false
        }
    }
    func needSecurityCode() -> Bool {
        guard let pmSelected = self.paymentOptionSelected else {
            return false
        }
        if pmSelected.isCustomerPaymentMethod() && self.paymentData.token == nil {
            return true
        }
        return false
    }

    func needCreateToken() -> Bool {
        
        guard let pm = self.paymentData.paymentMethod else {
            return false
        }
        return self.paymentData.token == nil && pm.isCard()
    }
    
    func shouldShowCongrats() -> Bool {
        return self.payment != nil
    }
    
    func shouldExitCheckout() -> Bool {
        return self.isCheckoutComplete()
    }
}