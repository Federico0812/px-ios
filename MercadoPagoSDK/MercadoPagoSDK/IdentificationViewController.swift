//
//  IdentificationViewController.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 5/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

open class IdentificationViewController: MercadoPagoUIViewController , UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    
    var tipoDeDocumentoLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var numberDocLabel: UILabel!
    @IBOutlet weak var numberTextField: HoshiTextField!
    
   // var identificationTypeLabel: UILabel?
   // var numberLabel: UILabel?
    
    var callback : (( Identification) -> Void)?
    var identificationTypes : [IdentificationType]?
    var identificationType : IdentificationType?
    var initialMask = TextMaskFormater(mask: "XXX.XXX.XXX", completeEmptySpaces: true,leftToRight: false)
    var defaultMask = TextMaskFormater(mask: "XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX.XXX", completeEmptySpaces: false,leftToRight: false)
    var indentificationMask = TextMaskFormater(mask: "XXX.XXX.XXX",completeEmptySpaces: false,leftToRight: false)
    var editTextMask = TextMaskFormater(mask: "XXXXXXXXXXXXXXXXXXXX",completeEmptySpaces: false,leftToRight: false)
    
    var toolbar : UIToolbar?
    
    var identificationView: UIView!
    var identificationCard : IdentificationCardView?

    
    @IBOutlet var typePicker: UIPickerView! = UIPickerView()
    
    
    override open var screenName : String { get { return "IDENTIFICATION_NUMBER" } }
    
    public init(callback : @escaping (( _ identification: Identification) -> Void)) {
        super.init(nibName: "IdentificationViewController", bundle: MercadoPago.getBundle())
        self.callback = callback
    }
    
    override func loadMPStyles(){
        var titleDict : NSDictionary = [:]
        if self.navigationController != nil {
            if let font = UIFont(name: MercadoPagoContext.getDecorationPreference().getFontName(), size: 18){
                titleDict = [NSForegroundColorAttributeName: UIColor.systemFontColor(), NSFontAttributeName: font]
            }
            if self.navigationController != nil {
                self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
                self.navigationItem.hidesBackButton = true
                self.navigationController!.interactivePopGestureRecognizer?.delegate = self
                self.navigationController?.navigationBar.tintColor = UIColor.px_white()
                self.navigationController?.navigationBar.barTintColor = UIColor.primaryColor()
                self.navigationController?.navigationBar.removeBottomLine()
                self.navigationController?.navigationBar.isTranslucent = false
                displayBackButton()
            }
        }
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 150, width: view.frame.width, height: 216))
        pickerView.backgroundColor = UIColor.px_white()
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.px_white()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "OK".localized, style: .plain, target: self, action: #selector(IdentificationViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        if let font = UIFont(name:MercadoPagoContext.getDecorationPreference().getFontName(), size: 14) {
            doneButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState())
          }

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar

    }

    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if (string.characters.count < 1){
            return true
        }
        if(textField.text?.characters.count == identificationType!.maxLength){
            return false
        }
        return true
    }
    
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
            self.remask(charactersCount: (textField.text?.characters.count)!)
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.numberDocLabel.resignFirstResponder()
        return true
    }
    
    open func editingChanged(_ textField:UITextField) {
          hideErrorMessage()
       
         numberDocLabel.text = indentificationMask.textMasked(editTextMask.textUnmasked(textField.text))
         textField.text = editTextMask.textMasked(textField.text,remasked: true)
    
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func donePicker(){
        textField.resignFirstResponder()
        numberTextField.becomeFirstResponder()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        identificationCard = IdentificationCardView()

        self.identificationView = UIView()

        
        let IDcardHeight = getCardHeight()
        let IDcardWidht = getCardWidth()
        let xMargin = (UIScreen.main.bounds.size.width  - IDcardWidht) / 2
        let yMargin = (UIScreen.main.bounds.size.height - 384 - IDcardHeight ) / 2
        
        let rectBackground = CGRect(x: xMargin, y: yMargin, width: IDcardWidht, height: IDcardHeight)
        let rect = CGRect(x: 0, y: 0, width: IDcardWidht, height: IDcardHeight)
        self.identificationView.frame = rectBackground
        identificationCard?.frame = rect
        self.identificationView.backgroundColor = UIColor(netHex: 0xEEEEEE)
        self.identificationView.layer.cornerRadius = 11
        self.identificationView.layer.masksToBounds = true
        self.view.addSubview(identificationView)
        identificationView.addSubview(identificationCard!)
        
        
        tipoDeDocumentoLabel = identificationCard?.tipoDeDocumentoLabel
        numberDocLabel = identificationCard?.numberDocLabel

        indentificationMask = defaultMask
        numberDocLabel.text = initialMask.textMasked("")
        self.tipoDeDocumentoLabel.text =  "DOCUMENTO DEL TITULAR DE LA TARJETA".localized
        self.numberTextField.placeholder = "Número".localized
        self.textField.placeholder = "Tipo".localized
        self.view.backgroundColor = UIColor.primaryColor()
        numberTextField.autocorrectionType = UITextAutocorrectionType.no
        numberTextField.keyboardType = UIKeyboardType.numberPad
        numberTextField.addTarget(self, action: #selector(IdentificationViewController.editingChanged(_:)), for: UIControlEvents.editingChanged)
        self.setupInputAccessoryView()
        self.getIdentificationTypes()
        typePicker.isHidden = true;
        
    }
    
    func getCardWidth() -> CGFloat {
        let widthTotal = UIScreen.main.bounds.size.width * 0.70
        if widthTotal < 512 {
            if ((0.63 * widthTotal) < (UIScreen.main.bounds.size.height - 394)){
                return widthTotal
            }else{
                return (UIScreen.main.bounds.size.height - 394) / 0.63
            }
            
        }else{
            return 512
        }
        
    }
    
    func getCardHeight() -> CGFloat {
        return ( getCardWidth() * 0.63 )
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.leftBarButtonItem!.action = #selector(invokeCallbackCancel)
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.hideLoading()
    }

    

    open func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
   open  

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(self.identificationTypes == nil){
            return 0
        }
       
        return self.identificationTypes!.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.identificationTypes![row].name
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        identificationType =  self.identificationTypes![row]
    //    typeButton.setTitle( self.identificationTypes![row].name, forState: .Normal)
        textField.text = self.identificationTypes![row].name
        typePicker.isHidden = true;
        self.remask()
        self.numberTextField.text = ""

    }
    
    @IBAction func setType(_ sender: AnyObject) {
        numberTextField.resignFirstResponder()
        typePicker.isHidden = false
        
    }

    var navItem : UINavigationItem?
    var doneNext : UIBarButtonItem?
    var donePrev : UIBarButtonItem?

    
    func setupInputAccessoryView() {

        let frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        let toolbar = UIToolbar(frame: frame)
        
        toolbar.barStyle = UIBarStyle.default;
        toolbar.backgroundColor = UIColor(netHex: 0xEEEEEE);
        toolbar.alpha = 1;
        toolbar.isUserInteractionEnabled = true
        
        let buttonNext = UIBarButtonItem(title: "Continuar".localized, style: .done, target: self, action: #selector(CardFormViewController.rightArrowKeyTapped))
        let buttonPrev = UIBarButtonItem(title: "Anterior".localized, style: .plain, target: self, action: #selector(CardFormViewController.leftArrowKeyTapped))
        
        let font = Utils.getFont(size: 14)
        buttonNext.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        buttonPrev.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        
        toolbar.items = [flexibleSpace, buttonPrev, flexibleSpace, buttonNext, flexibleSpace]
        
        buttonPrev.setTitlePositionAdjustment(UIOffset(horizontal: UIScreen.main.bounds.size.width / 8, vertical: 0), for: UIBarMetrics.default)
        buttonNext.setTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.size.width / 8, vertical: 0), for: UIBarMetrics.default)
        

        numberTextField.delegate = self
        self.toolbar = toolbar
        numberTextField.inputAccessoryView = toolbar
        
        
    }

    func rightArrowKeyTapped(){
        let idnt = Identification(type: self.identificationType?._id , number: editTextMask.textUnmasked(numberTextField.text))
        
        let cardToken = CardToken(cardNumber: "", expirationMonth: 10, expirationYear: 10, securityCode: "", cardholderName: "", docType: (self.identificationType?.type)!, docNumber:  editTextMask.textUnmasked(numberTextField.text))

        if ((cardToken.validateIdentificationNumber(self.identificationType)) == nil){
            self.numberTextField.resignFirstResponder()
            self.callback!(idnt)
            self.showLoading()
            self.view.bringSubview(toFront: self.loadingInstance!)
        }else{
            showErrorMessage((cardToken.validateIdentificationNumber(self.identificationType))!)
        }
       
    }
    
     var errorLabel : MPLabel?
    func showErrorMessage(_ errorMessage:String){
        errorLabel = MPLabel(frame: toolbar!.frame)
        self.errorLabel!.backgroundColor = UIColor(netHex: 0xEEEEEE)
        self.errorLabel!.textColor = UIColor(netHex: 0xf04449)
        self.errorLabel!.text = errorMessage
        self.errorLabel!.textAlignment = .center
        self.errorLabel!.font = self.errorLabel!.font.withSize(12)
        numberTextField.borderInactiveColor = UIColor.red
        numberTextField.borderActiveColor = UIColor.red
        numberTextField.inputAccessoryView = errorLabel
        numberTextField.setNeedsDisplay()
        numberTextField.resignFirstResponder()
        numberTextField.becomeFirstResponder()
        
        
        
    }
    
    func hideErrorMessage(){
        self.numberTextField.borderInactiveColor = UIColor(netHex: 0x3F9FDA)
        self.numberTextField.borderActiveColor = UIColor(netHex: 0x3F9FDA)
        self.numberTextField.inputAccessoryView = self.toolbar
        self.numberTextField.setNeedsDisplay()
        self.numberTextField.resignFirstResponder()
        self.numberTextField.becomeFirstResponder()
    }
    
    func leftArrowKeyTapped(){
        self.navigationController?.popViewController(animated: false)
        
    }
    
    fileprivate func getIdentificationTypes(){
        doneNext?.isEnabled = false
        MPServicesBuilder.getIdentificationTypes({ (identificationTypes) -> Void in
            self.hideLoading()
            self.doneNext?.isEnabled = true
            self.identificationTypes = identificationTypes
            self.typePicker.reloadAllComponents()
            self.identificationType =  self.identificationTypes![0]
            self.textField.text = self.identificationTypes![0].name
            self.numberTextField.becomeFirstResponder()
            self.remask()
            self.numberTextField.text = ""

            
            }, failure : { (error) -> Void in
                self.requestFailure(error, callback: {
                    self.dismiss(animated: true, completion: {})
                    self.getIdentificationTypes()
                    }, callbackCancel: {
                        if self.callbackCancel != nil {
                            self.callbackCancel!()
                        }
                    })
        })
    }
    
    fileprivate func getIdMask(IDtype: String)-> TextMaskFormater{
        let path = MercadoPago.getBundle()!.path(forResource: "IdentificationTypes", ofType: "plist")
        let dictID = NSDictionary(contentsOfFile: path!)
        let site = MercadoPagoContext.getSite()
        
        if let idConfig = dictID?.value(forKey: (site+"_"+(identificationType?._id!)!)) as? NSDictionary{
            if let etMask = idConfig.value(forKey: "identification_mask") as? String, etMask != ""{
                let mask = TextMaskFormater(mask: etMask,completeEmptySpaces: false,leftToRight: true)
                return(mask)
            }else if let idConfig = dictID?.value(forKey: (site)) as? NSDictionary{
                if let etMask = idConfig.value(forKey: "identification_mask") as? String, etMask != ""{
                    let mask = TextMaskFormater(mask: etMask,completeEmptySpaces: false,leftToRight: true)
                    return(mask)
                }else{
                    return defaultMask
                }
            }
        }else if let idConfig = dictID?.value(forKey: (site)) as? NSDictionary{
            if let etMask = idConfig.value(forKey: "identification_mask") as? String, etMask != ""{
                let mask = TextMaskFormater(mask: etMask,completeEmptySpaces: false,leftToRight: true)
                return(mask)
            }else{
                return defaultMask
            }
        
        }
        return defaultMask
    }

    
    
    fileprivate func remask(charactersCount: Int = 0){
        
        if charactersCount >= 1{
            if let IDtype = identificationType?._id{
                let mask = getIdMask(IDtype: IDtype)
                self.indentificationMask = mask
            }
        }else{
            self.indentificationMask = initialMask
            self.numberDocLabel.text = indentificationMask.textMasked("")
        }
        
        
    }
}



