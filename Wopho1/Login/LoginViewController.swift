//
//  LoginViewController.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 15.07.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Network
import Keychains
import StoreKit
import SwiftUI


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    
    // MARK: - Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var registryButton: UIButton!
    
    
//    @IBOutlet weak var topLoginConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLoginConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var milkView: UIView!
    @IBOutlet weak var secondMilkView: UIView!
    
    
    @IBOutlet weak var milkActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var milkLabel: UILabel!
    
    @IBOutlet weak var notInternetView: UIView!
    @IBOutlet weak var notInternetImage: UIImageView!
    @IBOutlet weak var notInternetLabel: UILabel!
    
    
    
    
    // MARK: - var / let
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var notInternetViewY: CGFloat = 0
    var notInternetDefaultY: CGFloat = 1000
    
    var companyArray = [CompanyUser]()
    var payed: Bool = false
    var uidForPayment = ""
    var uidMail = ""
    
    let yearlySubID = "price.for.one.year"
    var products: [String: SKProduct] = [:]
    
    

    struct tester {
        
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //paymentProducts()
        notInternetViewY = notInternetView.frame.origin.y
        notInternetView.frame.origin.y = notInternetDefaultY
        print("Constant Check---...-\(topLoginConstraint.constant)-..-")
        
        
        setupViews()
        addTargetToTextField()
        naviBarImage()
        activityIndicatorView.stopAnimating()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        AuthenticationService.automaticSingIn(onSuccess: {
//            self.loginButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//            self.loginButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
//            //self.autoLoginSetup()
//            //self.activityIndicatorView.startAnimating()
//
//
//            self.checkedLogin()
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//
//
//        })
        
        AuthenticationService.automaticSingInto {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.autoLoginSetup()
                UserApi.shared.observeCurrentUser { (uid) in
                    if uid.payment == true {
                        self.checkedLogin()
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        //self.milkActivityIndicator.stopAnimating()
                    } else {
                        if uid.uid != "" || uid.uid == nil {
                            self.uidForPayment = uid.uid!
                            self.uidMail = uid.email!
                        }
                        self.checkedLogin()
                        self.performSegue(withIdentifier: "isNotPayed", sender: self)
                        //self.milkActivityIndicator.stopAnimating()
                    }
                }
            }
        } onError: {
            self.checkedLogin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.checkInternet()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // AutoLogin erstmal lassen weil --- der Logout Button wird ein HomeButton hinzugefügt 
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        AuthenticationService.automaticSingIn(onSuccess: {
//            self.loginButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//            self.loginButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
//            //self.autoLoginSetup()
//            //self.activityIndicatorView.startAnimating()
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        })
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "isNotPayed" {
            let upgradeVC = segue.destination as! UpgradeViewController
            upgradeVC.userUid = uidForPayment
            upgradeVC.userMail = uidMail
            if uidMail != "" && uidForPayment != "" {
                upgradeVC.isRegistry = true
            }
//            upgradeVC.modalPresentationStyle = UIModalPresentationStyle.popover
//            upgradeVC.popoverPresentationController?.delegate = self
        }
    }
    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
    
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        UIView.animate(withDuration: 1.1) {
            if self.view.frame == CGRect(x: 0, y: 0, width: 375, height: 667) || self.view.frame == CGRect(x: 0, y: -80, width: 375, height: 667) {
                self.topLoginConstraint.constant = 65
                self.view.layoutIfNeeded()
                print("Iphone SE2")
            } else if self.view.frame == CGRect(x: 0, y: 0, width: 428, height: 926) {
                print("Iphone pro max")
            } else {
                self.topLoginConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 1.1) {
            self.topLoginConstraint.constant = 227
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - NEW PAYMENT
    
//    func receiptVali() {
//        let receiptURL = Bundle.main.appStoreReceiptURL
//        let receiptData = try? Data(contentsOf: receiptURL!)
//        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "1verson36Sandbox" as AnyObject]
//        
//        do {
//            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
//            let storeURL = URL(string: "")!
//            var storeRequest = URLRequest(url: storeURL)
//        }
//    }
    
    // MARK: - Payment // Subscription
    
    
    
    
    
    
    
    func paymentProducts() {
        let productID = Set([yearlySubID])
        let request = SKProductsRequest(productIdentifiers: productID)
        request.delegate = self
        request.start()
    }
    
    func refreshReceipt() {
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        request.start()
    }
    
    
    func refreshSubsStatus(callback: @escaping () -> Void, failure: @escaping (Error) -> Void) {
//        self.refreshSubSuccessBlock = callback
//        self.refreshSubFailureBlock = failure
        guard let reciptURL = Bundle.main.appStoreReceiptURL else {
            refreshReceipt()
            return
        }
        
        let urlSandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
        let urlAppStore = "https://buy.itunes.apple.com/verifyReceipt"
        
        let receiptData = try? Data(contentsOf: reciptURL).base64EncodedString()
        //let receiptData = try? Data(contentsOf: reciptURL)
        let requestDate = ["receipt-data" : receiptData ?? "", "password" : self, "exclude-old-transactions" : true] as [String : Any]
        var request = URLRequest(url: URL(string: urlSandbox)!)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: requestDate, options: [])
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if data != nil {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                        self.parseReceipt(json as! Dictionary<String, Any>)
                        return
                    }
                } else {
                    print("---- error oder was")
                }
            }
        }.resume()
    }
    
    func parseReceipt(_ json: Dictionary<String, Any>) {
        guard let receipts_array = json["latest_receipt_info"] as? [Dictionary<String, Any>] else { return }
        
        for receipt in receipts_array {
            let productID = receipt["price.for.one.year"] as! String
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            if let date = formatter.date(from: receipt["expires_date"] as! String) {
                if date > Date() {
                    UserDefaults.standard.set(date, forKey: productID)
                }
            }
        }
    }
    
    
//    public static func checkReceipt() -> Bool {
//
//    var date = NSDate()
//    var check = false
//
//    do {
//        let reqeust = try getReceiptRequest()
//        //let urlSandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
//        //var reqeust = URLRequest(url: URL(string: urlSandbox)!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: reqeust, completionHandler: {(data, response, error) -> Void in
//            guard let jsonData = data else { return }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: jsonData, options: .init(rawValue: 0)) as AnyObject
//                receiptStatus = ReceiptStatusError.statusForErrorCode(json.object(forKey: "status"))
//                guard let latest_receipt_info = (json as AnyObject).object(forKey: "latest_receipt_info") else { return }
//                guard let receipts = latest_receipt_info as? [[String: AnyObject]] else { return }
//                updateStatus(receipts: receipts)
//                var latest = receipts.last
//
//                date = NSDate()
//                if let result = latest!["expires_date"] as? String {
//                    let expireDate = result
//                    check = checkDifference(now: date, expireDate: expireDate)
//                    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.isValid = check
//                }
//
//            } catch _ {
//
//            }
//        })
//        task.resume()
//    } catch let error {
//        print("SKPaymentManager : Failure to process payment from Apple store: \(error)")
//        //checkReceiptInLocal()
//    }
//
//    return check
//
//    }

    /// check subscription is valid or not
//    fileprivate static func checkDifference(now: NSDate, expireDate: String) -> Bool{
//
//        // convert string to Date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
//        let expire = dateFormatter.date(from: expireDate)
//
//        let dateComponentsFormatter = DateComponentsFormatter()
//        dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfMonth,.day,.hour,.minute,.second]
//        dateComponentsFormatter.maximumUnitCount = 1
//        dateComponentsFormatter.unitsStyle = .full
//
//        dateComponentsFormatter.string(from: now as Date, to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
//        dateComponentsFormatter.string(from: expire!, to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
//
//        let seconds = expire?.seconds(from: now as Date)
//
//        if seconds! > 0 {
//            return true
//        }else{
//            return false
//        }
//
//    }
    
    
    // MARK: - Methode
//    func naviBarImage() {
//        let nav = self.navigationController?.navigationBar
//
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//        imageView.contentMode = .scaleAspectFit
//
//
//        let image = UIImage(named: "project1")
//        imageView.image = image
//
//        navigationItem.titleView = imageView
//    }
    
    // MARK: - Functions
    
    func checkInternet() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.yeahConnection()
                }
            } else {
                DispatchQueue.main.async {
                    self.noConnection()
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func yeahConnection() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear) {
            
        } completion: { (_) in
            self.notInternetView.frame.origin.y = -250
            self.notInternetView.isHidden = true
        }

    }
    
    func noConnection() {
        notInternetView.frame.origin.y = -250
        let notImageOfInternet = UIImage(systemName: "wifi.slash")
        notInternetImage.image = notImageOfInternet
        notInternetImage.tintColor = truqButtonColor
        notInternetLabel.lineBreakMode = .byWordWrapping
        notInternetLabel.textAlignment = .center
        notInternetLabel.text = "Keine Internetverbindung! \nBitte prüfe dein Netzwerk"
        notInternetView.isHidden = false
        disConfirmLoginButton()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    func naviBarImage() {
        self.navigationItem.titleView = navigationTitle(text: "App_Name")
    }
    
    func checkedLogin() {
        UIView.animate(withDuration: 0.1, delay: .zero, options: .curveEaseIn) {
            self.milkView.frame.origin.y += 800
            self.secondMilkView.frame.origin.y += 800
        } completion: { (_) in
            self.milkActivityIndicator.stopAnimating()
            self.milkActivityIndicator.isHidden = true
            self.milkLabel.isHidden = true
            self.secondMilkView.isHidden = true
            self.milkView.isHidden = true
        }
    }
    
    func checkedSuccessLogin() {
        self.milkActivityIndicator.stopAnimating()
//        self.milkActivityIndicator.isHidden = true
//        self.milkLabel.isHidden = true
//        self.secondMilkView.isHidden = true
//        self.milkView.isHidden = true
    }
    
    func navigationTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        return label
    }
    
//    func loadData() {
//        loginButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//        loginButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
//        loginButton.setTitle(" ", for: .normal)
//        activityIndicatorView.startAnimating()
//    }
    
    func autoLoginSetup() {
//        loginButton.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
//        loginButton.layer.cornerRadius = loginButton.bounds.height/2
        loginButton.setTitle(" ", for: .normal)
        loginButton.isEnabled = false
        activityIndicatorView.startAnimating()
    }
    
    func wrongData() {
        loginButton.backgroundColor = redColor
        loginButton.layer.cornerRadius = loginButton.bounds.height/2
        loginButton.tintColor = darkgrayButtonColor
        loginButton.layer.borderColor = loginButton.tintColor.cgColor
        loginButton.titleLabel?.lineBreakMode = .byWordWrapping
        loginButton.titleLabel?.textAlignment = .center
        loginButton.setTitle("Falsche Daten", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        loginButton.setTitleColor(darkgrayButtonColor, for: .normal)
        loginButton.isEnabled = false
    }
    
    func subEnd() {
        loginButton.backgroundColor = redColor
        loginButton.layer.cornerRadius = loginButton.bounds.height/2
        loginButton.tintColor = darkgrayButtonColor
        loginButton.layer.borderColor = loginButton.tintColor.cgColor
        loginButton.titleLabel?.lineBreakMode = .byWordWrapping
        loginButton.titleLabel?.textAlignment = .center
        loginButton.setTitle("Abo ausgelaufen", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        loginButton.setTitleColor(darkgrayButtonColor, for: .normal)
        loginButton.isEnabled = false
    }
    
    func setupViews() {
//        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        emailTextField.borderStyle = .roundedRect
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let placeholderEmail = NSAttributedString(string: "E-Mail", attributes: attribute)
        let placeholderPassword = NSAttributedString(string: "Passwort", attributes: attribute)
        emailTextField.attributedPlaceholder = placeholderEmail
        passwordTextField.attributedPlaceholder = placeholderPassword
        
//        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        passwordTextField.borderStyle = .roundedRect
        
        emailTextField.textColor = .white
        passwordTextField.textColor = .white
        
        emailTextField.backgroundColor = .clear
        passwordTextField.backgroundColor = .clear
        
        milkActivityIndicator.layer.cornerRadius = 5
        milkActivityIndicator.layer.masksToBounds = true
        milkActivityIndicator.backgroundColor = .lightGray
        
        registryButton.backgroundColor = truqButtonColor
        registryButton.layer.cornerRadius = 10
        registryButton.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = secondMilkView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        secondMilkView.addSubview(blurEffectView)
        
        notInternetView.layer.cornerRadius = 5
        
        disConfirmLoginButton()
    }
    
    func disConfirmLoginButton() {
        loginButton.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        loginButton.layer.borderWidth = 0
        loginButton.layer.cornerRadius = loginButton.bounds.height/2
        loginButton.tintColor = .white
        loginButton.setTitleColor(darkgrayButtonColor, for: .normal)
        loginButton.isEnabled = false
    }
    
    func confirmLoginButton() {
        loginButton.backgroundColor = .white
        loginButton.layer.borderWidth = 3
        loginButton.tintColor = truqButtonColor
        loginButton.layer.borderColor = loginButton.tintColor.cgColor
        loginButton.setTitleColor(truqButtonColor, for: .normal)
        loginButton.isEnabled = true
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func addTargetToTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange() {
        let isText = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && notInternetView.isHidden == true 
        
        if isText {
            confirmLoginButton()
        } else {
            disConfirmLoginButton()
        }
    }
    
    // MARK: - Payment TEST
    
    
    
    // MARK: - Action
    
    @IBAction func registryButtonTapped(_ sender: UIButton) {
//        refreshSubsStatus {
//            print("----der Test Funktioniert")
//        } failure: { (error) in
//            print("----NOOOOOOOOOOO \(error)")
//        }

        performSegue(withIdentifier: "isNotPayed", sender: self)
        
//        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
//            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
//
//            do {
//                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
//                print(receiptData)
//
//                let receiptString = receiptData.base64EncodedString(options: [])
//                print("was da los 2.0 \(receiptData)")
//                // Read receiptData
//            }
//            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
//        }
        
        //print("payed start \(companyArray.count)")
        //UIApplication.shared.openURL("https://apps.apple.com/account/subscriptions")
//        UIApplication.shared.open(URL(string: "https://api.storekit.itunes.apple.com/inApps/v1/subscriptions/{originalTransactionId}")!, options: [:], completionHandler: nil)
        //Linking.openURL("https://apps.apple.com/account/subscriptions")
        //performSegue(withIdentifier: "isNotPayed", sender: self)
        //let test = UIApplication.shared.openURL("https://sandbox.itunes.apple.com/verifyReceipt")
        
//        for i in self.companyArray {
//            self.payed = i.payed
//            print("payed --- ? -> \(self.payed) && coreData -> \(i.postUid)")
//        }
//        if payed == false {
//            performSegue(withIdentifier: "toUpgradeVC", sender: self)
//        } else if payed == true {
//            performSegue(withIdentifier: "isNotPayed", sender: self)
//        }
    }
    
    
    @IBAction func unwindFromUpgrade(_ unwindSegue: UIStoryboardSegue) {
        checkedLogin()
        activityIndicatorView.stopAnimating()
        disConfirmLoginButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = darkgrayButtonColor
    }
    
    @IBAction func unwindFromLogout(_ unwindSegue: UIStoryboardSegue) {
        passwordTextField.text = ""
        emailTextField.text = ""
        setupViews()
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = darkgrayButtonColor
        activityIndicatorView.stopAnimating()
    }
    
//    @IBAction func unwindFromRegistry(_ unwindSegue: UIStoryboardSegue) {
//        passwordTextField.text = ""
//        emailTextField.text = ""
//        setupViews()
//        loginButton.setTitle("Login", for: .normal)
//        loginButton.tintColor = darkgrayButtonColor
//    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        self.autoLoginSetup()
        AuthenticationService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            let saveSucces : Bool = Keychain.setPassword(self.passwordTextField.text!, forAccount: "companyInformation")
            
            if saveSucces == true {
                print("______Passwort gespeichert______")
            }
            UserApi.shared.observeCurrentUser { (uid) in
                if uid.payment == true {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    if uid.uid != "" || uid.uid == nil {
                        self.uidForPayment = uid.uid!
                        self.uidMail = uid.email!
                    }
                    self.performSegue(withIdentifier: "isNotPayed", sender: self)
                }
            }
            //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            self.activityIndicatorView.stopAnimating()
        }) { (error) in
            self.activityIndicatorView.stopAnimating()
            self.wrongData()
            print(error!)
        }
    }
}

extension LoginViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
            print("Wrong ->-> \(product)")
            print("-< PayTest >- Ungültig")
        }
        
        response.products.forEach { product in
            products[product.productIdentifier] = product
            
            print("-< PayTest >- BEZAHLT --- \(product.subscriptionPeriod?.numberOfUnits)")
            print("-< PayTest >- 1111BEZAHLT --- \(product.productIdentifier)")
        }
        
    }
    
    
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error -> -> \(error.localizedDescription) <- <-")
        print("-< PayTest >- Fehler")
    }
    
    
    
    
}
