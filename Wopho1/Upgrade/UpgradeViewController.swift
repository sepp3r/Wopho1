//
//  UpgradeViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 19.12.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import StoreKit
import PassKit

class UpgradeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    
    
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var checkForPrivacy: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var subTester: UIButton!
    
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var confirmed: Bool = false
    var isRegistry: Bool = false
    var userUid = ""
    var userMail = ""
    var amount: Double = 00.01
    
    let yearlySubID = "price.for.one.year"
    var products: [String: SKProduct] = [:]
    
    let _product = [Product.SubscriptionInfo.Status]()
    
    var currentSubscription: Product?
    var status: Product.SubscriptionInfo.Status?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        paymentProducts()
        sdfsdf()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUpgradeInfoVC" {
            let detailVC = segue.destination as! UpgradeInfoViewController
        }
    }
    
    func sdfsdf() {
        for i in _product {
            switch i.state {
            case .subscribed:
                print("---> sub")
            case .expired:
                print("---> past was net")
            default:
                print("---> default")
            }
            
        }
    }
    
    func setupView() {
        detailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        detailButton.backgroundColor = truqButtonColor
        detailButton.layer.cornerRadius = 5
        detailButton.clipsToBounds = true
        if confirmed == true {
            confirmedPrivacyAndTerms()
        } else if confirmed == false {
            notConfirmedPrivacyAndTerms()
        }
    }
    
    func confirmedPrivacyAndTerms() {
        upgradeButton.backgroundColor = truqButtonColor
        upgradeButton.layer.cornerRadius = 5
        upgradeView.layer.borderColor = upgradeView.tintColor.cgColor
        upgradeView.tintColor = .white
        upgradeView.layer.borderWidth = 2.5
        upgradeView.layer.cornerRadius = 10
        upgradeView.clipsToBounds = true
        upgradeButton.isEnabled = true
        let image = UIImage(systemName: "checkmark.circle.fill")
        checkForPrivacy.setImage(image, for: .normal)
        checkForPrivacy.imageView?.tintColor = truqButtonColor
        checkForPrivacy.tintColor = truqButtonColor
        confirmed = true
    }
    
    func notConfirmedPrivacyAndTerms() {
        upgradeButton.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        upgradeButton.layer.cornerRadius = 5
        upgradeView.layer.borderColor = upgradeView.tintColor.cgColor
        upgradeView.tintColor = .lightGray
        upgradeView.layer.borderWidth = 2.5
        upgradeView.layer.cornerRadius = 10
        upgradeView.clipsToBounds = true
        upgradeButton.isEnabled = false
        let image = UIImage(systemName: "circle")
        checkForPrivacy.setImage(image, for: .normal)
        checkForPrivacy.imageView?.tintColor = .black
        checkForPrivacy.tintColor = .black
        checkForPrivacy.backgroundColor = .clear
        confirmed = false
    }
        
    
    // MARK: - Alert Function
    func defaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - NEW PAYMENT
    func fetchAvailableProduct() {
        let productID = Set([yearlySubID])
        let request = SKProductsRequest(productIdentifiers: productID)
        request.delegate = self
        request.start()
    }
    
//    func productsRequest(_ request: SKProductsRequest, didRecevie response: SKProductsResponse) {
//        if (response.products.count > 0) {
//
//        }
//    }
    
    func validateReceipt() {
        let recURL = Bundle.main.appStoreReceiptURL!
        let contents = NSData(contentsOf: recURL)
        let receiptData = contents!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(receiptData)
        let requestContents = ["receipt-data" : receiptData]
        print(requestContents)
        let requestData = try? JSONSerialization.data(withJSONObject: requestContents, options: [])
        print(requestData)
        let serverURL = "https://sandbox.itunes.apple.com/verifyReceipt" // TODO:change this in production with https://buy.itunes.apple.com/verifyReceipt
        let url = NSURL(string: serverURL)
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.httpBody = requestData
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Hast NICHT Bezahlt --- 0")
            guard let data = data, error == nil else {
                //self.notifyReceiptResult(false)
                print("Hast NICHT Bezahlt --- 1")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                print("Hast NICHT Bezahlt --- 1.5 \(json)")
                if let receipt = json?["receipt"] as? [String: AnyObject],
                    let inApp = receipt["in_app"] as? [AnyObject] {
                    print(inApp)
                    print("Hast NICHT Bezahlt --- 1.6")
                    if (inApp.count > 0) {
                        //self.notifyReceiptResult(true)
                        print("Hast ---- Bezahlt --- 1 \(inApp)")
                    } else {
                        //self.notifyReceiptResult(false)
                        print("Hast NICHT Bezahlt --- 2")
                    }
                }
            }
            catch let error as NSError {
                print(error)
                //self.notifyReceiptResult(false)
                print("Hast NICHT Bezahlt --- 3")
            }
        })
        task.resume()
    }
    
    
    
    // MARK: - Payment Setup
    
    
    
    func paymentProducts() {
        let productID = Set([yearlySubID])
        let request = SKProductsRequest(productIdentifiers: productID)
        request.delegate = self
        request.start()
        
    }
    
    func purchasing(productId: String) {
        if let product = products[productId] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    
    func applePayPayment() {
        let paymentItem = PKPaymentSummaryItem.init(label: "Business Zugang", amount: NSDecimalNumber(value: amount))
        
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa, .girocard]
        
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "EUR"
            request.countryCode = "DE"
            request.merchantIdentifier = "merchant.merchant.Sebastian-Schmitt.Wopho1"
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = paymentNetworks
            request.paymentSummaryItems = [paymentItem]
            request.requiredShippingContactFields = [.emailAddress, .name]
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                defaultAlert(title: "Error", message: "Transaktion leider nicht möglich!")
                return }
            paymentVC.delegate = self
            present(paymentVC, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Action
    @IBAction func unwindFromUpgradeInfo(_ unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindFromRegistry(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is RegistrationViewController {
            if let senderVC = unwindSegue.source as? RegistrationViewController {
                isRegistry = senderVC.toRegister
                userMail = senderVC.emailTextField.text!
            }
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromUpgrade", sender: self)
    }
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showUpgradeInfoVC", sender: self)
    }
    
    @IBAction func checkForPrivacyTapped(_ sender: UIButton) {
        if confirmed == true {
            notConfirmedPrivacyAndTerms()
        } else if confirmed == false {
            confirmedPrivacyAndTerms()
        }
    }
    
    @IBAction func termsOfServiceButtonTapped(_ sender: UIButton) {
        tabBarController!.selectedIndex = 2
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        tabBarController!.selectedIndex = 2
    }
    
    @IBAction func subTesterTapp(_ sender: UIButton) {
        validateReceipt()
    }
    
    
    @IBAction func upgradeButtonTapped(_ sender: UIButton) {
        if isRegistry == false {
            performSegue(withIdentifier: "atFirstRegistry", sender: self)
        } else {
            //applePayPayment()
            //purchasing(productId: yearlySubID)
            // MARK: - only for testing
            print("mailoderwas- \(userMail)")
            AuthenticationService.uploadPaymentData(payed: true, amount: amount, email: userMail) {
                self.performSegue(withIdentifier: "isPayed", sender: self)
            } onError: { error in
                self.defaultAlert(title: "Fehler!", message: "Die Transaktion hat nicht funktioniert")
            }
        }
    }
}

extension UpgradeViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        AuthenticationService.uploadPaymentData(payed: true, amount: amount, email: userMail) {
            self.performSegue(withIdentifier: "isPayed", sender: self)
        } onError: { error in
            self.defaultAlert(title: "Fehler!", message: "Die Transaktion hat nicht funktioniert")
        }
    }
}

extension UpgradeViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
        }
        
        response.products.forEach { product in
            products[product.productIdentifier] = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error -> -> \(error.localizedDescription) <- <-")
    }
}


