//
//  PreviewViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 25.01.21.
//  Copyright © 2021 Sebastian Schmitt. All rights reserved.
//

import UIKit
import Photos


class PreviewViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var scanLayerView: UIView! {
        didSet {
            scanLayerView.layer.cornerRadius = 5
            scanLayerView.layer.borderWidth = 2
            scanLayerView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 2.5
            scrollView.minimumZoomScale = 0.95
            scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            scrollView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var topAlphaView: UIView! {
        didSet {
            topAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    
    @IBOutlet weak var bottomAlphaVIew: UIView! {
        didSet {
            bottomAlphaVIew.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var previewImageExchanger: UIImage?
    var returnImage: UIImage?
    var incomeSegue = ""
    
    
    // für PAN-Gesture
    var initialCenter = CGPoint()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
//        setupImage()
        thePickerController()
        print("was ist zuerst geladen -> 2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if backImage.image != nil {
            backImage.image = nil
            thePickerController()
        } else {
            thePickerController()
        }
        print("was ist zuerst geladen -> ")
    }
    
    // MARK: - Editor Setup
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backImage
    }
    
    private func addCameraView() {
        if previewImageExchanger != nil {
            
            backImage.image = previewImageExchanger
            backImage.contentMode = .scaleAspectFit
            self.addCameraLayer()
            
        }
    }
    
    private func addCameraLayer() {
        UIGraphicsBeginImageContext(self.view.bounds.size)
        let cgContext = UIGraphicsGetCurrentContext()
        cgContext?.fill(self.view.bounds)
        cgContext?.clear(CGRect(x: self.scanLayerView.frame.origin.x, y: self.scanLayerView.frame.origin.y, width: self.scanLayerView.bounds.width, height: self.scanLayerView.bounds.height))
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let maskView = UIView(frame: self.view.bounds)
        maskView.layer.contents = maskImage?.cgImage
        maskView.layer.cornerRadius = 10
        self.view.mask = maskView
//        self.backImage.contentMode = .scaleAspectFill
    }
    
    func fixOrientation(image: UIImage, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            if (image.imageOrientation == .up) {
                completion(image)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(normalizedImage)
    }
    
    func croppedImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat, completion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.main.async {
            let imageViewScale = max(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
            print("scal- imageViewScale \(imageViewScale)")

            let imageAspectRatio = inputImage.size.height/inputImage.size.width
            print("scal- imageASPECTRatio \(imageAspectRatio)")

            let cropZone = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale, width: cropRect.size.width * imageViewScale, height: cropRect.size.height * imageViewScale)
            print("crop Zone- spring \(cropZone)")
            guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)

            else {
                return
            }
    //        let croppededImage: UIImage = UIImage(cgImage: cutImageRef)
            let croppededImage: UIImage = UIImage(cgImage: cutImageRef, scale: inputImage.imageRendererFormat.scale, orientation: inputImage.imageOrientation)
            completion(croppededImage)
        }
        
        
        
        
//        DispatchQueue.global(qos: .background).async {
//            let imageViewScale = max(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
//
//            let cropZone = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale, width: cropRect.size.width * imageViewScale, height: cropRect.size.height * imageViewScale)
//            print("crop Zone- spring \(cropZone)")
//            guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
//
//            else {
//                return
//            }
//    //        let croppededImage: UIImage = UIImage(cgImage: cutImageRef)
//            let croppededImage: UIImage = UIImage(cgImage: cutImageRef, scale: inputImage.imageRendererFormat.scale, orientation: inputImage.imageOrientation)
//            completion(croppededImage)
//        }

    }
    
    func croppingImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        
        let imageViewScale = max(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
        
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale, width: cropRect.size.width * imageViewScale, height: cropRect.size.height * imageViewScale)
        print("crop Zone- spring \(cropZone)")
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)

        else {
            return nil
        }
        
        

//        let croppededImage: UIImage = UIImage(cgImage: cutImageRef)
        let croppededImage: UIImage = UIImage(cgImage: cutImageRef, scale: inputImage.imageRendererFormat.scale, orientation: inputImage.imageOrientation)
        return croppededImage
    }
    
//    func cropTest(image: UIImage) -> UIImage {
//
//        let tester = image.cgImage?.renderingIntent
//
//        let croppedTest: UIImage = UIImage(cgImage: tester as! CGImage, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
//
//        return croppedTest
//    }
    
    
    // MARK: - Setup View
    
    func setupImage() {
        view.isHidden = false
        activityIndicator.isHidden = true
        
//        let croppering = cropTest(image: previewImageExchanger!)
//        backImage.image = croppering
        
        
        
        backImage.image = previewImageExchanger
        backImage.layer.cornerRadius = 5
        backImage.clipsToBounds = true
        
        scanLayerView.translatesAutoresizingMaskIntoConstraints = false
        print("Frame of_ Preview -> \(backImage.frame)")
    }
    
    func thePickerController() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        
        present(pickerController, animated: true, completion: nil)
        print("was ist zuerst geladen -> 3")
        print("ist segue der Fehler 4_ \(self.incomeSegue)")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("was ist zuerst geladen -> DISMISS")
        previewImageExchanger = info[.originalImage] as? UIImage
        dismiss(animated: true) {
            if self.previewImageExchanger != nil {
                self.setupImage()
            }
        }
        print("ist segue der Fehler 2_ \(self.incomeSegue)")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("was ist zuerst geladen -> CANCELLED")
        if incomeSegue == "editSegue" {
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "unwindPreviewForCompanyImage", sender: self)
            }
        } else {
            dismiss(animated: true) {
                self.performSegue(withIdentifier: "undwindFromPreview", sender: self)
            }
        }
    }
    
    
    
    // MARK: - Unwind Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "unwindPreviewToCompanyHome" {
//            let unwindPreviewToCompanyHome = segue.destination as! CompanyHomeViewController
//            unwindPreviewToCompanyHome.newImageForCard = self.returnImage
//        }
//
//        if segue.identifier == "unwindPreviewFromCancel" {
//
//        }
        if segue.identifier == "showShareVC" {
            let showShareVC = segue.destination as! ShareViewController
            showShareVC.newImageFromLibrary = self.returnImage
            showShareVC.stringForUnwind = "backToGalleryVC"
        }
    }
    
    // MARK: - Pinch and Scale
    
    @objc func pinchGesture(pinchGesture: UIPinchGestureRecognizer) {
        
        if pinchGesture.state == .recognized {
            UIView.animate(withDuration: 0.2) {
//                self.backImage.transform = CGAffineTransform.identity
//                pinchGesture.view?.transform = .identity
                print("was ist der scale --22--- \(self.backImage.transform)")
                
                
            }
//        if let view = pinchGesture.view {
//            view.transform = view.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
//            pinchGesture.scale = 1
        } else if backImage.transform.a >= 1.0 && backImage.transform.d >= 1.0 {
            pinchGesture.view?.transform = (pinchGesture.view?.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale))!
            pinchGesture.scale = 1.0
            }
    }
    
    @objc func panGesture(panGesture: UIPanGestureRecognizer) {
        let pan = panGesture.view!
        let translation = panGesture.translation(in: pan.superview)
        
        if panGesture.state == .began {
            self.initialCenter = pan.center
            
        }
        
        if panGesture.state == .ended {
        } else if panGesture.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            pan.center = newCenter
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // MARK: - Action
    @IBAction func unwindFromShareByGallery(_ unwindSegue: UIStoryboardSegue) {
        if backImage.image != nil {
            backImage.image = nil
            thePickerController()
        } else {
            thePickerController()
        }
        print("ist segue der Fehler 5_ \(self.incomeSegue)")
    }
    
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
//        if backImage.image != nil {
//            backImage.image = nil
//            performSegue(withIdentifier: "unwindPreviewFromCancel", sender: self)
//        } else {
//            performSegue(withIdentifier: "unwindPreviewFromCancel", sender: self)
//        }
        
        if backImage.image != nil {
            backImage.image = nil
            if self.incomeSegue == "editSegue" {
                self.performSegue(withIdentifier: "unwindPreviewForCompanyImage", sender: self)
            } else {
                performSegue(withIdentifier: "undwindFromPreview", sender: self)
            }
        } else {
            if self.incomeSegue == "editSegue" {
                self.performSegue(withIdentifier: "unwindPreviewForCompanyImage", sender: self)
            } else {
                performSegue(withIdentifier: "undwindFromPreview", sender: self)
            }
            
        }
    }
    
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        
        guard let imageCrop = backImage.image else { return }
        
        
        
        let cropRect = CGRect(x: scanLayerView.frame.origin.x - backImage.reallyImageRect().origin.x, y: scanLayerView.frame.origin.y - backImage.reallyImageRect().origin.y, width: scanLayerView.frame.width, height: scanLayerView.frame.height)
        
        
//            let imageCropped = self.croppingImage(fixedImage, toRect: cropRect, viewWidth: self.backImage.frame.width, viewHeight: self.backImage.frame.height)
        self.fixOrientation(image: imageCrop) { fixedImage in
                DispatchQueue.main.async {
                    self.croppedImage(fixedImage, toRect: cropRect, viewWidth: self.backImage.frame.width, viewHeight: self.backImage.frame.height) { endImage in
                        self.scrollView.zoomScale = 1
                        self.returnImage = endImage
//                        self.performSegue(withIdentifier: "showShareVC", sender: self)
            //            self.backImage.image = imageCropped
                        print("ist segue der Fehler 1_ \(self.incomeSegue)")
                        
                        if self.incomeSegue == "ShowPreviewVC" {
                            self.performSegue(withIdentifier: "showShareVC", sender: self)
                        } else if self.incomeSegue == "editSegue" {
                            self.performSegue(withIdentifier: "unwindPreviewForCompanyImage", sender: self)
                        }
                }
            }
            
        }
        
//        let imageCropped = croppingImage(imageCrop, toRect: cropRect, viewWidth: backImage.frame.width, viewHeight: backImage.frame.height)
        
        
//        returnImage = imageCropped
        
//        self.performSegue(withIdentifier: "unwindPreviewToCompanyHome", sender: self)
    }
}

extension UIImageView {
    
    func reallyImageRect() -> CGRect {
        let imageViewSize = self.frame.size
        let imageSize = self.image?.size
        
        guard let imagSize = imageSize else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imagSize.width
        let scaleHeight = imageViewSize.height / imagSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imagRect = CGRect(x: 0, y: 0, width: imagSize.width * aspect, height: imagSize.height * aspect)
        
        imagRect.origin.x = (imageViewSize.width - imagRect.size.width) / 2
        imagRect.origin.y = (imageViewSize.height - imagRect.size.height) / 2
        
        
        imagRect.origin.x += self.frame.origin.x
        imagRect.origin.y += self.frame.origin.y
        
        
        return imagRect
    }
}

extension UIView {
    func border() {
        self.backgroundColor = .clear
        self.clipsToBounds = true

        let masklayer = CAShapeLayer()
        masklayer.frame = bounds
        masklayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.mask = masklayer

        let line = NSNumber(value: Float(self.bounds.width * 4))
        let borderLayer = CAShapeLayer()
        borderLayer.path = masklayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineDashPattern = [line]
        borderLayer.lineDashPhase = self.bounds.width / 4
        borderLayer.lineWidth = 30
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
