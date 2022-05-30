//
//  RegistrationViewController.swift
//  PiCCO
//
//  Created by Sebastian Schmitt on 15.07.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Security
import Network
import Keychains

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlet
//    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var companyImageBlur: UIImageView!
    
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var bottomCreateButton: NSLayoutConstraint!
//    @IBOutlet weak var verticalImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalImageConstraint: NSLayoutConstraint!
//    @IBOutlet weak var constraintButtonTop: NSLayoutConstraint!
    @IBOutlet weak var topOfTheImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var repeatEmailLabel: UILabel!
    
    
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordEqualLabel: UILabel!
    //@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var testMeinView: UIView!
    
    @IBOutlet weak var notInternetView: UIView!
    @IBOutlet weak var notInternetLabel: UILabel!
    @IBOutlet weak var notInternetImage: UIImageView!
    
    
    
    
//    @IBOutlet weak var registScroll: UIScrollView!
    
    
    // MARK: - var / let
    
    var selectedImage: UIImage?
    var redColor = UIColor(displayP3Red: 229/277, green: 77/277, blue: 77/277, alpha: 1.0)
    var darkgrayButtonColor = UIColor(displayP3Red: 61/277, green: 61/277, blue: 61/277, alpha: 1.0)
    var truqButtonColor = UIColor(displayP3Red: 0, green: 139/277, blue: 139/277, alpha: 0.75)
    
    var notInternetViewY: CGFloat = 0
    var notInternetDefaultY: CGFloat = 1000
    var toRegister: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternet()
        notInternetViewY = notInternetView.frame.origin.y
        notInternetView.frame.origin.y = notInternetDefaultY
        
        addTragetToTextField()
        addTapGestureToCompanyView()
        activityIndicator.stopAnimating()
        setupView()
        naviSetup()
        
        self.companyTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        keyboardIsComing()
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        keyboardGoes()
    }
    
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
//        registScroll.isScrollEnabled = true
//        registScroll.endEditing(true)
//        registScroll.keyboardDismissMode = .onDrag
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view wird wieder angezeigt 1.0")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view wird wieder angezeigt 2.0")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreviewByRegister" {
            let showPreviewPic = segue.destination as! PreviewUserPicViewController
            showPreviewPic.view.isHidden = true
            showPreviewPic.incomeSegue = "unwindToRegister"
        }
    }
    
    
    func keyboardIsComing() {
        UIView.animate(withDuration: 1.1) {
            print("wo ist constant --- if --- \(self.view.frame.debugDescription)")
            if self.view.frame == CGRect(x: 0, y: 0, width: 375, height: 667) || self.view.frame == CGRect(x: 0, y: -80, width: 375, height: 667) {
                self.view.frame.origin.y = -80
                self.registrationLabel.isHidden = true
                self.bottomCreateButton.constant = +180
//                self.bottomCreateButton.constant = 5
                self.verticalImageConstraint.constant = 5
//                self.constraintButtonTop.constant = 5
                self.topOfTheImageConstraint.constant = 85
                self.view.layoutIfNeeded()
                self.companyImageView.translatesAutoresizingMaskIntoConstraints = true
                self.companyImageBlur.translatesAutoresizingMaskIntoConstraints = true
                self.companyImageView.layoutIfNeeded()
                self.companyImageBlur.layoutIfNeeded()
                self.companyImageView.frame.size.height = 80
                self.companyImageView.frame.size.width = 80
                self.companyImageBlur.frame.size.height = 80
                print("wo ist constant --- iPhone SE && 8 --- \(self.view.frame.debugDescription)")
            } else if self.view.frame == CGRect(x: 0, y: 0, width: 428, height: 926) {
                self.topOfTheImageConstraint.constant = 50
                self.bottomCreateButton.constant = +330
                self.view.layoutIfNeeded()
                
                print("iphone pro max")
            } else {
                self.view.frame.origin.y = -120
                self.registrationLabel.isHidden = true
                self.bottomCreateButton.constant = +195
//                self.bottomCreateButton.constant = 10
                self.verticalImageConstraint.constant = 10
//                self.constraintButtonTop.constant = 10
                self.topOfTheImageConstraint.constant = 130
                self.view.layoutIfNeeded()
                print("wo ist constant ---§§else§§--- \(self.view.frame.debugDescription)")
            }

        }
    }
    
    func keyboardGoes() {
        UIView.animate(withDuration: 1.1) {
            print("wo ist constant GOES--- if --- \(self.view.frame.debugDescription)")
            if self.view.frame == CGRect(x: 0, y: 0, width: 375, height: 667) || self.view.frame == CGRect(x: 0, y: -80, width: 375, height: 667) {
                self.view.frame.origin.y = 0
                self.registrationLabel.isHidden = false
                self.bottomCreateButton.constant -= 140
                self.verticalImageConstraint.constant = 25
//                self.constraintButtonTop.constant = 144
                self.view.layoutIfNeeded()
                self.companyImageView.translatesAutoresizingMaskIntoConstraints = false
                self.companyImageView.layoutIfNeeded()
                self.companyImageView.frame.size.height = 100
                self.companyImageView.frame.size.width = 100
                self.companyImageBlur.translatesAutoresizingMaskIntoConstraints = false
                //self.companyImageBlur.layoutIfNeeded()
                //self.companyImageBlur.frame.size.height = 104
            } else if self.view.frame == CGRect(x: 0, y: 0, width: 428, height: 926) {
                self.topOfTheImageConstraint.constant = 113.67
                self.bottomCreateButton.constant = 43
                self.view.layoutIfNeeded()
            } else if self.view.frame.origin.y != 0 {
                print("wo ist constant DIE ELSE FUNKTION \(self.view.frame.debugDescription)")
                self.view.frame.origin.y = 0
                self.registrationLabel.isHidden = false
                self.bottomCreateButton.constant -= 160
                self.verticalImageConstraint.constant = 25
//                self.constraintButtonTop.constant = 144
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("keyboard geht zurück ---ää-----")
        companyTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    func emailIsValid(email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("Invalid email id")
        }
        print("mail Validate ____ \(valid)")
        return valid
    }
    
    
    
    // MARK: - Methoden
    func setupView() {
        companyImageView.layer.cornerRadius = companyImageView.bounds.width/2
        companyImageView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        let blueEffectImage = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectImageView = UIVisualEffectView(effect: blueEffectImage)
        blurEffectImageView.frame = companyImageBlur.bounds
        blurEffectImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        companyImageBlur.addSubview(blurEffectImageView)
        companyImageBlur.layer.cornerRadius = 10
        companyImageBlur.clipsToBounds = true
        companyImageBlur.backgroundColor = .clear
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let placeholderCompany = NSAttributedString(string: "Name Unternehmen", attributes: attribute)
        let placeholderEmail = NSAttributedString(string: "E-Mail", attributes: attribute)
        let placeholderPassword = NSAttributedString(string: "Passwort", attributes: attribute)
        let placeholderRepeatPassword = NSAttributedString(string: "Passwort wiederholen", attributes: attribute)
        
        companyTextField.attributedPlaceholder = placeholderCompany
        emailTextField.attributedPlaceholder = placeholderEmail
        passwordTextField.attributedPlaceholder = placeholderPassword
        repeatPasswordTextField.attributedPlaceholder = placeholderRepeatPassword
        activityIndicator.color = truqButtonColor
        activityIndicator.tintColor = truqButtonColor
    
//        companyTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        companyTextField.borderStyle = .roundedRect
        companyTextField.textColor = .white
        companyTextField.backgroundColor = .clear
        
//        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        emailTextField.borderStyle = .roundedRect
        emailTextField.textColor = .white
        emailTextField.backgroundColor = .clear
        
//        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        
//        repeatPasswordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
//        repeatPasswordTextField.borderStyle = .roundedRect
        repeatPasswordTextField.textColor = .white
        repeatPasswordTextField.backgroundColor = .clear
        
        notInternetView.layer.cornerRadius = 5
        
        
        disconfirmRegistryButton()
        passwordEqualLabel.isHidden = true
        print("bist es du ???????")
    }
    
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
        disconfirmRegistryButton()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.notInternetView.frame.origin.y = self.notInternetViewY
        } completion: { (_) in
            
        }

    }
    
    func inValidEmail() {
        createAccountButton.backgroundColor = redColor
        createAccountButton.layer.borderWidth = 3
        createAccountButton.tintColor = darkgrayButtonColor
        print("farben Fehler 66666")
        createAccountButton.layer.borderColor = createAccountButton.tintColor.cgColor
        createAccountButton.layer.cornerRadius = createAccountButton.bounds.height/2
        createAccountButton.isEnabled = false
        createAccountButton.titleLabel?.lineBreakMode = .byWordWrapping
        createAccountButton.titleLabel?.textAlignment = .center
        createAccountButton.setTitle("Ungültige E-mail", for: .normal)
        createAccountButton.setTitleColor(darkgrayButtonColor, for: .normal)
    }
    
    
    func disconfirmRegistryButton() {
        createAccountButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
        createAccountButton.layer.cornerRadius = createAccountButton.frame.width/2
        createAccountButton.layer.borderWidth = 0
        createAccountButton.tintColor = .white
//        print("farben Fehler 111111")
        createAccountButton.setTitleColor(darkgrayButtonColor, for: .normal)
        createAccountButton.isEnabled = false
    }
    
    func choosePhoto() {
        
        let fieldFullFilled = companyTextField.text?.count ?? 0>0 && emailTextField.text?.count ?? 0>0 && passwordTextField.text?.count ?? 0>0 && repeatPasswordTextField.text?.count ?? 0>0 && passwordTextField.text == repeatPasswordTextField.text && notInternetView.isHidden == true
        
//        if passwordTextField.text?.count == 0 || repeatPasswordTextField.text?.count == 0 || companyTextField.text?.count == 0 || emailTextField.text?.count == 0 {
//            disconfirmRegistryButton()
//        } else {
//            confirmRegistryButton()
//        }
        
        
        if fieldFullFilled {
            confirmRegistryButton()
        } else {
            disconfirmRegistryButton()
        }
        
//        print("Farbe welche genau \(createAccountButton.tintColor)")
//        print("Farbe welche genau zweitew----\(createAccountButton.tintColor)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let characterString = CharacterSet(charactersIn: "^°`´*+'#;,äÄöÖüÜ|{}()><€§$%&?!ß")
//        if let range = string.rangeOfCharacter(from: characterString) {
//            print("\(range)---------------keine Sonderzeichen")
//            return false
//        }
//
//        return true
//        let specialCharacterText = emailTextField.text?.emailIsValid()
        
//        if passwordTextField.text?.count == 50000 {
//            print("sonderzeichen läuft immer noch schief")
//        } else {
//            passwordEqualLabel.isHidden = false
//            passwordEqualLabel.textColor = .white
//            passwordEqualLabel.font = UIFont.italicSystemFont(ofSize: 8)
//            passwordEqualLabel.text = "keine sonderzeichen erlaubt!!!!"
//        }
//        let emailTrimming = emailTextField.text?.trimmingCharacters(in: .whitespaces)
//
//        if emailIsValid(email: emailTrimming!) == false {
//            print("Sonderzeichen die Prüfung funktioniert-----------")
//
//
//
//        } else {
//            print("ungültige Email")
//        }
        
        return true
    }

    
    func addTragetToTextField() {
        companyTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        
        let fieldFullFilled = companyTextField.text?.count ?? 0>0 && emailTextField.text?.count ?? 0>0 && passwordTextField.text?.count ?? 0>0 && repeatPasswordTextField.text?.count ?? 0>0 && passwordTextField.text == repeatPasswordTextField.text && notInternetView.isHidden == true
        
        
//        let isText = companyTextField.text?.count ?? 0>0 && emailTextField.text?.count ?? 0>0 && passwordTextField.text?.count ?? 0>0 && repeatPasswordTextField.text?.count ?? 0>0 && passwordTextField.text == repeatPasswordTextField.text
        
//        let specialCharacterText = emailTextField.text?.emailIsValid()
        
//        let compareText = companyTextField.text?.count ?? 0>0 || emailTextField.text?.count ?? 0>0
//        let comparePassword = passwordTextField.text?.count ?? 0>0 || repeatPasswordTextField.text?.count ?? 0>0
        
        if passwordTextField.text!.count >= repeatPasswordTextField.text!.count && passwordTextField.text != repeatPasswordTextField.text && notInternetView.isHidden == true {
            
            disconfirmRegistryButton()
            
            
        } else if fieldFullFilled {
            
            confirmRegistryButton()
            createAccountButton.setTitle("Registrieren", for: .normal)
            createAccountButton.isEnabled = true
            passwordEqualLabel.isHidden = true
            repeatEmailLabel.isHidden = false
            
        } else if passwordTextField.text?.count == repeatPasswordTextField.text?.count && passwordTextField.text != repeatPasswordTextField.text {
            repeatEmailLabel.isHidden = true
            disconfirmRegistryButton()
//            createAccountButton.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
//            createAccountButton.layer.cornerRadius = createAccountButton.bounds.height/2
//            createAccountButton.tintColor = .white
            createAccountButton.isEnabled = false
            passwordEqualLabel.isHidden = false
//            passwordEqualLabel.textColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
            passwordTextField.textColor = .white
            passwordEqualLabel.textColor = redColor
            passwordEqualLabel.font = UIFont.italicSystemFont(ofSize: 12)
            passwordEqualLabel.text = "Passwort ist nicht identisch!"
            
        } else if passwordTextField.text!.count <= repeatPasswordTextField.text!.count && passwordTextField.text != repeatPasswordTextField.text {
            repeatEmailLabel.isHidden = true
            disconfirmRegistryButton()
            createAccountButton.isEnabled = false
            passwordEqualLabel.isHidden = false
            passwordTextField.textColor = .white
            passwordEqualLabel.textColor = redColor
            passwordEqualLabel.font = UIFont.italicSystemFont(ofSize: 12)
            passwordEqualLabel.text = "Passwort ist nicht identisch!"
            
        } else if passwordTextField.text?.count != repeatPasswordTextField.text?.count {
            repeatEmailLabel.isHidden = false
            passwordEqualLabel.isHidden = true
            passwordEqualLabel.text = "--------"
            
        } else if passwordTextField.text?.count == 0 || repeatPasswordTextField.text?.count == 0 || companyTextField.text?.count == 0 || emailTextField.text?.count == 0 {
            passwordEqualLabel.isHidden = true
            repeatEmailLabel.isHidden = false
            print("alles ist falsch")
        }
//        print("ich versteht das nicht ----- ")
    }
    
    func loadRegistry() {
//        createAccountButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 0)
//        createAccountButton.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
        createAccountButton.setTitle(" ", for: .normal)
        createAccountButton.isEnabled = false
        print("farben Fehler 3333333")
        activityIndicator.startAnimating()
    }
    
    func mistakeRegistry() {
        createAccountButton.backgroundColor = redColor
        createAccountButton.layer.cornerRadius = createAccountButton.bounds.height/2
        createAccountButton.tintColor = darkgrayButtonColor
        createAccountButton.layer.borderColor = createAccountButton.tintColor.cgColor
        print("farben Fehler 77777")
        createAccountButton.titleLabel?.lineBreakMode = .byWordWrapping
        createAccountButton.titleLabel?.textAlignment = .center
        createAccountButton.setTitle("Fehler beim Laden", for: .normal)
        createAccountButton.setTitleColor(darkgrayButtonColor, for: .normal)
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        createAccountButton.isEnabled = false
    }
    
    func confirmRegistryButton() {
        createAccountButton.backgroundColor = .white
        createAccountButton.layer.borderWidth = 3
        createAccountButton.tintColor = truqButtonColor
        createAccountButton.layer.borderColor = createAccountButton.tintColor.cgColor
        createAccountButton.setTitleColor(truqButtonColor, for: .normal)
        createAccountButton.isEnabled = true
        print("richtige farbe 555555")
        createAccountButton.setTitle("Registrieren", for: .normal)
        print("Farbe welche genau 2222 \(createAccountButton.tintColor)")
    }
    
    // MARK: - Choose Photo
    func addTapGestureToCompanyView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectCompanyPhoto))
        companyImageView.addGestureRecognizer(tapGesture)
        companyImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectCompanyPhoto() {
        performSegue(withIdentifier: "showPreviewByRegister", sender: self)
        
//        let pickerController = UIImagePickerController()
//        pickerController.delegate = self
//        pickerController.allowsEditing = true
//        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            companyImageView.image = editImage
            companyImageView.backgroundColor = .clear
            //companyImageBlur.image = editImage
            selectedImage = editImage
            choosePhoto()
        } else if let originalImage = info[.originalImage] as? UIImage {
            companyImageView.image = originalImage
            companyImageView.backgroundColor = .clear
            //companyImageBlur.image = originalImage
            selectedImage = originalImage
            choosePhoto()
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NavigationBar Setup
    func naviSetup() {
        navigationItem.titleView = navigationTitle(text: "App_Name")
    }
    
    func navigationTitle(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.center = label.center
        label.font = UIFont.italicSystemFont(ofSize: 20)
        
        return label
    }
    
    // MARK: - Action
    
    @IBAction func unwindFromPreviewUserPic(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is PreviewUserPicViewController {
            if let senderVC = unwindSegue.source as? PreviewUserPicViewController {
                if senderVC.returnImage == nil {
                    companyImageView.layer.cornerRadius = companyImageView.bounds.width/2
                    companyImageView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
                    companyImageView.image = nil
                    companyImageView.image = UIImage(named: "placeholderCompanyImage2")
                } else {
                    companyImageView.image = senderVC.returnImage
                    selectedImage = senderVC.returnImage
                    choosePhoto()
                }
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromRegistry", sender: nil)
    }
    
    
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        
        if emailTextField.text!.count > 0 {
            if emailIsValid(email: self.emailTextField.text!) {
                view.endEditing(true)
                loadRegistry()
                if selectedImage == nil {
                    createAccountButton.backgroundColor = redColor
                    print("farben Fehler 888888")
                    createAccountButton.tintColor = darkgrayButtonColor
                    createAccountButton.layer.borderColor = createAccountButton.tintColor.cgColor
                    createAccountButton.setTitle("Foto wählen", for: .normal)
                    createAccountButton.setTitleColor(darkgrayButtonColor, for: .normal)
                    activityIndicator.stopAnimating()
                    return
                }

                // Save Password
//                let saveSucces : Bool = Keychain.save(self.passwordTextField.text!, forKey: "companyInformation")
//
//                if saveSucces == true {
//                    print("Passwort gespeichert")
//                }
                
                let saveSucces : Bool = Keychain.setPassword(self.passwordTextField.text!, forAccount: "companyInformation")
                
                if saveSucces == true {
                    print("Passwort gespeichert")
                }

                guard let image = selectedImage else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        //        AuthenticationService.createCompany(username: companyTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                AuthenticationService.createCompany(username: companyTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                    self.toRegister = true
                    self.performSegue(withIdentifier: "unwindFromRegistry", sender: nil)
                    //self.performSegue(withIdentifier: "registerSegue", sender: nil)
                    self.activityIndicator.stopAnimating()
                }) { (error) in
                    print(error!)
                    self.activityIndicator.stopAnimating()
                    self.mistakeRegistry()
                    self.toRegister = false
                }
            } else {
                print("2.0-----Ungültig-----")
                inValidEmail()
                toRegister = false
            }
        }
        
        
    }
}

//extension String {
//    func emailIsValid() -> Bool {
//        let text = try? NSRegularExpression(pattern: "^(((([a-zA-Z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])+(\\.([a-zA-Z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])+)*)|((\\x22)((((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(([\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x7f]|\\x21|[\\x23-\\x5b]|[\\x5d-\\x7e]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(\\([\\x01-\\x09\\x0b\\x0c\\x0d-\\x7f]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}]))))*(((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(\\x22)))@((([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])([a-zA-Z]|\\d|-|\\.|_|~|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])*([a-zA-Z]|\\d|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])))\\.)+(([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])|(([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])([a-zA-Z]|\\d|-|_|~|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])*([a-zA-Z]|[\\x{00A0}-\\x{D7FF}\\x{F900}-\\x{FDCF}\\x{FDF0}-\\x{FFEF}])))\\.?$", options: .caseInsensitive)
//        return text?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
//    }
//}


