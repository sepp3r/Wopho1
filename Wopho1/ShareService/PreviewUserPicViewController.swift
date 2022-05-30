//
//  PreviewUserPicViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 10.02.22.
//  Copyright © 2022 Sebastian Schmitt. All rights reserved.
//

import UIKit
import Photos

class PreviewUserPicViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Layout
//    @IBOutlet weak var scanLayerView: UIView! {
//        didSet {
            
//        }
//    }
    
    @IBOutlet weak var scanLayerView: UIView! {
        didSet {
            scanLayerView.layer.cornerRadius = scanLayerView.bounds.width/2
            scanLayerView.layer.borderWidth = 2
            scanLayerView.layer.borderColor = UIColor.white.cgColor
            scanLayerView.isHidden = false
        }
    }
    
    
    
//    @IBOutlet weak var scrollView: UIScrollView! {
//        didSet {
            
//        }
//    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 2.5
            scrollView.minimumZoomScale = 0.95
            scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            scrollView.layer.cornerRadius = 5
        }
    }
    
    
//    @IBOutlet weak var topAlphaView: UIView! {
//        didSet {
//            topAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        }
//    }
    
    @IBOutlet weak var topAlphaView: UIView! {
        didSet {
            topAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    
//    @IBOutlet weak var middleAlphaView: UIView! {
//        didSet {
//            middleAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        }
//    }
    
    @IBOutlet weak var middleAlphaView: UIView! {
        didSet {
            middleAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    
//    @IBOutlet weak var bottomAlphaView: UIView! {
//        didSet {
//            bottomAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        }
//    }
    
    @IBOutlet weak var bottomAlphaView: UIView! {
        didSet {
            bottomAlphaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var abortButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
//    @IBOutlet weak var backImage: UIImageView!
//    @IBOutlet weak var abortButton: UIButton!
//    @IBOutlet weak var chooseButton: UIButton!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - var / let
    var previewImageExchanger: UIImage?
    var returnImage: UIImage?
    var incomeSegue = ""
    
    var _center = CGPoint(x: 0, y: 0)
    
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
        thePickerController()
        _center = scanLayerView.center
//        middleAlphaView.addSubview(scanLayerView)
        
        
        scanLayerView.translatesAutoresizingMaskIntoConstraints = false
        let top = scanLayerView.topAnchor.constraint(equalTo: topAlphaView.bottomAnchor)
        let bottom = scanLayerView.bottomAnchor.constraint(equalTo: bottomAlphaView.topAnchor)
        let left = scanLayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2)
        let right = scanLayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2)
        NSLayoutConstraint.activate([top, bottom, left, right])
        scanLayerView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if backImage.image != nil {
            backImage.image = nil
            thePickerController()
        } else {
            thePickerController()
        }
    }
    
    
    
    
    // MARK: - Editor Setup
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //scanLayerView.frame = middleAlphaView.bounds
        print("scanlayer frame --- \(scrollView.zoomScale) && backImage frame \(scrollView.contentOffset)")
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.clipsToBounds = true
//        scanLayerView.frame = backImage.frame
        
//        _zoomScale = scrollView.zoomScale
        
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
//        scanLayerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
//        scanLayerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scanLayerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = backImage.center
//
//        _center = scanLayerView.center
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = middleAlphaView.center
//        scanLayerView.isUserInteractionEnabled = false
////        scanLayerView.contentMode = .center
        
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = scrollView.center
//        view.addSubview(scanLayerView)
        print("bewegst du dich --1")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = middleAlphaView.center
        
//        scanLayerView.isUserInteractionEnabled = false
//        scanLayerView.contentMode = .center
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
        //scanLayerView.center = scrollView.center
        
//        scanLayerView.frame = scrollView.frame
        //scanLayerView.translatesAutoresizingMaskIntoConstraints = false
//        scanLayerView.bounds.origin.x = scrollView.contentOffset.x
//        scanLayerView.bounds.origin.y = scrollView.contentOffset.y
        //scanLayerView.bounds.origin.y = scrollView.contentInset
        //scanLayerView.layer.position.x = scrollView.contentOffset.x
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = backImage.center
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
//        scanLayerView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
//        // Do the same for Y axis
//        scanLayerView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor)
        print("bewegst du dich ----\(scrollView.contentOffset)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = middleAlphaView.center
//        scanLayerView.isUserInteractionEnabled = false
//        scanLayerView.contentMode = .center
//        scanLayerView.translatesAutoresizingMaskIntoConstraints = true
//        scanLayerView.center = scrollView.center
        print("bewegst du dich --3")
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //scanLayerView.frame = middleAlphaView.bounds
    }
    
    
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
        // scanLayerView
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
    }
    
    func croppingImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        
        let imageViewScale = max(inputImage.size.width / viewWidth, inputImage.size.height / viewHeight)
        
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale, y: cropRect.origin.y * imageViewScale, width: cropRect.size.width * imageViewScale, height: cropRect.size.height * imageViewScale)
        print("crop Zone- spring \(cropZone)")
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)

        else {
            return nil
        }
        
        let croppededImage: UIImage = UIImage(cgImage: cutImageRef, scale: inputImage.imageRendererFormat.scale, orientation: inputImage.imageOrientation)
        return croppededImage
    }
    
    // MARK: - Setup View
    func setupImage() {
        view.isHidden = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        activityIndicator.isHidden = true
        
        //shadowView is a UIView of what I want to be "solid"
        

        //croppingView is a subview of shadowView that is laid out in interface builder using auto layout
        //croppingView is hidden.
        
//        circlePath.apply(CGAffineTransform(translationX: scanLayerView.frame.origin.x, y: scanLayerView.frame.origin.y))
//        circlePath.bounds.origin.y = scanLayerView.bounds.origin.y
//        circlePath.bounds.origin.x = scanLayerView.bounds.origin.x
        //outerPath.apply(<#T##transform: CGAffineTransform##CGAffineTransform#>)
        
        //outerPath.apply(CGAffineTransform(translationX: scanLayerView.frame.origin.x, y: scanLayerView.frame.origin.y))
        
        
        var outerPath = UIBezierPath(rect: middleAlphaView.bounds)
        var circlePath = UIBezierPath(ovalIn: scanLayerView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(circlePath)


        var maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.white.cgColor
        middleAlphaView.layer.mask = maskLayer
        middleAlphaView.isUserInteractionEnabled = false
        scanLayerView.isUserInteractionEnabled = false
        //scanLayerView.layer.mask = maskLayer
        
        
        //maskLayer.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: topAlphaView.bounds.size.width, height: topAlphaView.bounds.size.height)
        //maskLayer.position = CGPoint(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y)
        
//        middleAlphaView.clipsToBounds = false
//        middleAlphaView.translatesAutoresizingMaskIntoConstraints = false
        //maskLayer.position = CGPoint(x: backImage.bounds.origin.x, y: backImage.bounds.origin.y)
        
        //topAlphaView.center = scanLayerView.center
        
//        let croppering = cropTest(image: previewImageExchanger!)
//        backImage.image = croppering
        
//        let radius: CGFloat = scanLayerView.frame.size.width
//        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), cornerRadius: 0)
//        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2 / radius, height: 2 / radius), cornerRadius: radius)
//        path.append(circlePath)
//        path.usesEvenOddFillRule = true
//
//        let fillLayer = CAShapeLayer()
//        fillLayer.path = path.cgPath
//        fillLayer.fillRule = .evenOdd
//        fillLayer.fillColor = view.backgroundColor?.cgColor
//        fillLayer.opacity = 0.5
//        view.layer.addSublayer(fillLayer)
        
        backImage.image = previewImageExchanger
        backImage.layer.cornerRadius = 5
        backImage.clipsToBounds = true
        
        //scanLayerView.translatesAutoresizingMaskIntoConstraints = true
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
        
        if self.incomeSegue == "unwindToRegister" {
            self.performSegue(withIdentifier: "unwindToRegister", sender: self)
        } else if self.incomeSegue == "unwindToCompHome" {
            self.performSegue(withIdentifier: "unwindToCompHome", sender: self)
        }
//        if incomeSegue == "editSegue" {
//            dismiss(animated: true) {
//                self.performSegue(withIdentifier: "unwindPreviewForCompanyImage", sender: self)
//            }
//        } else {
//            dismiss(animated: true) {
//                self.performSegue(withIdentifier: "undwindFromPreview", sender: self)
//            }
//        }
    }
    
    // MARK: - Unwind Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Pinch and Scale
    @objc func pinchGesture(pinchGesture: UIPinchGestureRecognizer) {
        
        if pinchGesture.state == .recognized {
            UIView.animate(withDuration: 0.2) {
                print("was ist der scale --22--- \(self.backImage.transform)")
            }
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
    
    
    
//    @IBAction func abortButtonTapped(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "unwindToRegister", sender: self)
//    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        if self.incomeSegue == "unwindToRegister" {
            self.performSegue(withIdentifier: "unwindToRegister", sender: self)
        } else if self.incomeSegue == "unwindToCompHome" {
            self.performSegue(withIdentifier: "unwindToCompHome", sender: self)
        }
        print("klappt das überhautp ->>>>  abort tap")
    }
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        //middleAlphaView.contentScaleFactor = 2.5
        //middleAlphaView.frame = backImage.frame
        
        //scanLayerView.center = backImage.center
        guard let imageCrop = backImage.image else { return }



        let cropRect = CGRect(x: scanLayerView.frame.origin.x - backImage.reallyImageRect().origin.x, y: scanLayerView.frame.origin.y - backImage.reallyImageRect().origin.y, width: scanLayerView.frame.width, height: scanLayerView.frame.height)
        self.fixOrientation(image: imageCrop) { fixedImage in
                DispatchQueue.main.async {
                    self.croppedImage(fixedImage, toRect: cropRect, viewWidth: self.backImage.frame.width, viewHeight: self.backImage.frame.height) { endImage in
                        print("scanlayer frame --- RETURN \(cropRect)")
                        self.returnImage = endImage
                        

                        if self.incomeSegue == "unwindToRegister" {
                            self.performSegue(withIdentifier: "unwindToRegister", sender: self)
                            self.scrollView.zoomScale = 1.0
                        } else if self.incomeSegue == "unwindToCompHome" {
                            self.performSegue(withIdentifier: "unwindToCompHome", sender: self)
                            self.scrollView.zoomScale = 1.0
                        }
                }
            }
        }
    }
    
    
//    @IBAction func chosseButtonTapped(_ sender: UIButton) {
//        
//    }
}

extension UIImageView {
    
    func reallyImageRects() -> CGRect {
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
    func borders() {
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
