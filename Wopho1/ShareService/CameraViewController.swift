//
//  CameraViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 15.12.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol previewPicture {
    func imageFromTheCam(image: UIImage)
}

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var reventButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var previewPhotoView: UIImageView!
    @IBOutlet weak var ActivityIndi: UIActivityIndicatorView!
    @IBOutlet weak var picForPostButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    
    
    
    // MARK: var / let
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var previewImage: UIImage?
    let camera = AVCapturePhotoSettings()
    
    // description
    // 2=isOn || 3=isOff || 1=isAuto
    var iHaveFlash = 0
    
    // evtl. gelöscht werden
    var flashAuto = 0
    var flashOn = 0
    var flashOff = 0
    // ende
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //constraintSetup()
        setupCaptureSession()
        viewSetup()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: - Statusbar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Unwind Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShareVC" {
//            let unwindToCompanyHome = segue.destination as! CompanyHomeViewController
//            unwindToCompanyHome.newImageForCard = self.previewImage
            let showShareVC = segue.destination as! ShareViewController
            showShareVC.newImageFromLibrary = self.previewImage
            showShareVC.stringForUnwind = "showShareVC"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.cancel()
            }
        } else if segue.identifier == "ShowPreviewVC" {
            let seguePreviewVC = segue.destination as! PreviewViewController
            seguePreviewVC.view.isHidden = true
            seguePreviewVC.incomeSegue = "ShowPreviewVC"
//            seguePreviewVC.thePickerController()
//            print("was ist zuerst geladen -> 1")
            
        }
    }
    
    // MARK: - Setup View
    func constraintSetup() {
        previewPhotoView.translatesAutoresizingMaskIntoConstraints = true
//        let top = previewPhotoView.topAnchor.constraint(equalTo: topAlphaView.bottomAnchor)
//        let bottom = previewPhotoView.bottomAnchor.constraint(equalTo: bottomAlphaView.topAnchor)
        let left = previewPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let right = previewPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([left, right])
        previewPhotoView.contentMode = .scaleAspectFill
    }
    
    func viewSetup() {
        print("-----_____wer_kommt_zuerst____-----")
//        saveButton.layer.cornerRadius = saveButton.bounds.width / 2
        saveButton.isHidden = true
//        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
//        saveButton.setTitle("speichern?", for: .normal)
//        saveButton.tintColor = .white
//        saveButton.backgroundColor = .gray
//        previewPhotoView.contentMode = .scaleAspectFill
//        previewPhotoView.translatesAutoresizingMaskIntoConstraints = true
        
        if previewImage != nil {
            previewPhotoView.image = previewImage
        }
        
        picForPostButton.isHidden = true
        ActivityIndi.isHidden = true
        ActivityIndi.stopAnimating()
//        cameraButton.backgroundColor = .white
    }
    
    
    
    func savedImageSetup() {
//        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
//        saveButton.setTitle("gespeichert", for: .normal)
//        saveButton.tintColor = .white
////        saveButton.backgroundColor = UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 1.0)
//        saveButton.backgroundColor = .purple
        ActivityIndi.stopAnimating()
        ActivityIndi.isHidden = true
        cancel()
    }
    
    func mistakeSavedSetup() {
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 8)
        saveButton.setTitle("fehler", for: .normal)
        saveButton.tintColor = .red
//        saveButton.backgroundColor = .red
        ActivityIndi.stopAnimating()
        ActivityIndi.isHidden = true
    }
    
    // MARK: - Camera
    
//    func flashCheck() {
//
//    }
    
    func autoFlashSetup() {
        let image = UIImage(systemName: "bolt.badge.a")
        flashButton.setImage(image, for: .normal)
        flashButton.imageView?.tintColor = UIColor(displayP3Red: 0, green: 139, blue: 139, alpha: 0.75)
//        flashButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func onFlashSetup() {
        let image = UIImage(systemName: "bolt")
        flashButton.setImage(image, for: .normal)
        flashButton.imageView?.tintColor = UIColor(displayP3Red: 0, green: 139, blue: 139, alpha: 0.75)
    }
    
    func offFlashSetup() {
        let image = UIImage(systemName: "bolt.slash")
        flashButton.setImage(image, for: .normal)
        flashButton.imageView?.tintColor = UIColor(displayP3Red: 0, green: 139, blue: 139, alpha: 0.75)
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        
        do {
            guard let device = captureDevice else { return }
            
            let input = try AVCaptureDeviceInput(device: device)
            if device.hasFlash {
                switch camera.flashMode {
                case .on:
                    iHaveFlash += 2
                    onFlashSetup()
                    print("----ich habe den flash---ON--")
                case .off:
                    iHaveFlash += 3
                    offFlashSetup()
                    print("----ich habe den flash---OFF---")
                default:
                    iHaveFlash += 1
                    autoFlashSetup()
                    print("----ich habe den flash---AUTO--")
                }
            }
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
            }
            
        } catch let error {
            
        }
        
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        if((captureDevice?.isFocusModeSupported(.continuousAutoFocus)) != nil) {
            try! captureDevice?.lockForConfiguration()
            captureDevice?.focusMode = .continuousAutoFocus
            captureDevice?.unlockForConfiguration()
        }
        
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        //previewPhotoView.clipsToBounds = true
        constraintSetup()
        cameraPreviewLayer.frame = previewPhotoView.frame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        
        
        
        
        
//        var bounds: CGRect
//        bounds = previewPhotoView.layer.frame
//        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        cameraPreviewLayer.bounds = bounds
//        cameraPreviewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        
        
//        cameraPreviewLayer.contentsGravity = .resizeAspectFill
//        previewPhotoView.contentMode = .scaleAspectFill
//        cameraPreviewLayer.videoGravity = .resizeAspectFill
//        cameraPreviewLayer.connection?.videoOrientation = .portrait
//        cameraPreviewLayer.frame = self.view.frame
////        cameraPreviewLayer.frame = self.previewPhotoView.layer.frame
//        previewPhotoView.layer.frame = cameraPreviewLayer.frame
        
//        cameraPreviewLayer.frame = CGRect(x: 5, y: 100, width: 384, height: 515)
        
        
        
//        self.view.layer.addSublayer(cameraPreviewLayer)
        
//        cameraPreviewLayer.bounds = bounds
//        previewPhotoView.alpha = 0.5
        
        
//        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
//        self.previewPhotoView.layer.addSublayer(cameraPreviewLayer)
        
        
        captureSession.startRunning()
    }
    
    // MARK: - Delegate
    var delegateImage: previewPicture?
    
    @objc func handleThePicture() {
        guard let picture = previewImage else { return }
        delegateImage?.imageFromTheCam(image: picture)
        print("----bild wird an Post Car übergeben")
    }
    
    // MARK: - Cancel
    
    func cancel() {
        previewPhotoView.image = nil
        saveButton.isHidden = true
        picForPostButton.isHidden = true
        cameraButton.isHidden = false
        cameraSwitchButton.isHidden = false
        galleryButton.isHidden = false
        flashButton.isHidden = false
    }
    
    // MARK: - Save and Sent functions
    
    func savePhoto() {
        let library = PHPhotoLibrary.shared()
        guard let image = previewPhotoView.image else { return }
        previewImage = previewPhotoView.image
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.mistakeSavedSetup()
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.savedImageSetup()
                }
                return
            }
        }    }
    
    // MARK: - Photo Setup
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        if iHaveFlash == 1 {
            settings.flashMode = .auto
        } else if iHaveFlash == 2 {
            settings.flashMode = .on
        } else if iHaveFlash == 3 {
            settings.flashMode = .off
        }
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        photoOutput.capturePhoto(with: settings, delegate: self)    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            previewPhotoView.image = UIImage(data: imageData)
            constraintSetup()
//            previewImage = UIImage(data: imageData)
            
            saveButton.isHidden = false
            picForPostButton.isHidden = false
//            cameraButton.backgroundColor = .gray
//            cameraButton.isEnabled = false
            cameraButton.isHidden = true
            cameraSwitchButton.isHidden = true
            flashButton.isHidden = true
            galleryButton.isHidden = true
        }
    }
    
    func photoAnimate() {
        UIView.animate(withDuration: 0.5) {
            self.previewPhotoView.alpha = 0.0
        }
        UIView.animate(withDuration: 0.5) {
            self.previewPhotoView.alpha = 1.0
        }
    }
    
    func switchCamera() {
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        var newDevice: AVCaptureDevice?
        
        if  input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            guard let device = newDevice else { return }
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error {
            
        }
        
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
    func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }

    
    
    // MARK: - Action
    @IBAction func reventButtonTapped(_ sender: UIButton) {
        if previewPhotoView.image != nil {
            cancel()
        } else {
//            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "unwindToCompanyHome", sender: self)
        }
    }

    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        photoAnimate()
        takePhoto()
        
    }
    
    @IBAction func flashButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            switch self.iHaveFlash {
            case 1:
                self.onFlashSetup()
                self.iHaveFlash = 2
            case 2:
                self.offFlashSetup()
                self.iHaveFlash = 3
            case 3:
                self.autoFlashSetup()
                self.iHaveFlash = 1
            default:
                print("du hast keinen Blitz")
            }
        }
    }
    
    
    // MARK: - Switch Camera
    @IBAction func cameraSwitchButtonTapped(_ sender: UIButton) {
        switchCamera()
    }
    
    @IBAction func picForPostButtonTapped(_ sender: UIButton) {
        if previewPhotoView.image != nil {
            previewImage = previewPhotoView.image
            performSegue(withIdentifier: "showShareVC", sender: self)
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("image 4 \(previewImage.debugDescription)")
        ActivityIndi.isHidden = false
        ActivityIndi.startAnimating()
        savePhoto()
        handleThePicture()
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowPreviewVC", sender: self)
        
    }
    
    @IBAction func unwindFromPreview(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromShareByCam(_ unwindSegue: UIStoryboardSegue) {
        
    }

}
