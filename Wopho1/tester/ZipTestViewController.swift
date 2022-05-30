//
//  ZipTestViewController.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 07.07.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import UIKit
import CoreLocation

class ZipTestViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var coordinationLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    lazy var geocoderUserUid = CLGeocoder()
    
    // test for radius
    let locationManager = CLLocationManager()
    
    // Test f. Längen & Breitengrade zusammen in let / var -> -> f. processResponer der beiden Koordinaten abfragen
//    var coordinates = CLLocation(latitude: 0, longitude: 0)
    var coordinatesLatitude = 0.0
    var coordinatesLongitude = 0.0
    
    var coordinateUserUid = CLLocation(latitude: 0, longitude: 0)
    var coordinateLatitude: Double = 0.0
    var coordinateLongitude: Double = 0.0
    // ENDE
    
    var zipCounter: Int = 0
    
    // test array f. längen und breitengrade
    
//    var coorArray: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 50.0949253, longitude: 10.7936499), CLLocationCoordinate2D(latitude: 49.8169042, longitude: 10.9890053)]
    
//    var coorArray2: [CLLocation(] = []
    
//    var test789: [CLLocation] = [CLLocation(latitude: 50.0949253, longitude: 10.7936499), CLLocation(latitude: 49.8169042, longitude: 10.9890053)]
    
    // ENDE
    
    // neuer Test mit Datenbank
    
    var radiusUser = 25000.0
    var radiusCompany: Double = 0.0
    
    var latLong: [CLLocation] = [CLLocation(latitude: 0.0, longitude: 0.0)]
    var radiusUs: [Double] = []
    
    var latitude = 0.0
    var longitude = 0.0
    
    var company = [UserModel]()
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            setupUserRadiusInfo(user: _user)
        }
    }
    
    
    // Ende - Test mit Datenbank Abruf
    
    var userUid = ""
    
    // Array´s zum testn
    var userZipCode: [String] = []
    var userZip = ""
    
    var userUidArray: [String] = []
    var id = ""
    
    
    let radius: Double = 25000
    // end
    
    
    var distanceTest: CLLocationDistance = 0.0
    var distance = [CLLocationDistance]()
    
    func testDistance() {
        distanceTest = radius
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("dic coor.-<-<-<-<-<-", test789)
        loadTheUsers()
        loadAllUsers()
        print("ZipCode ViewDidLoad->", self.userZipCode)
        print("die latLong", latLong)
//        allUserCoordinate()
        // test for radius
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        setupLocation()
        // end
    }
    
    func setupUserRadiusInfo(user: UserModel) {
//        func processResponseUser(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
//            if let error = error {
//                print("Hat nicht funktioniert die Koor. Abfrage")
//            } else {
//                var location: CLLocation?
//                if let placemarks = placemarks, placemarks.count > 0 {
//                    location = placemarks.first?.location
//                }
//
//                if let location = location {
//                    let coordinate = location.coordinate
//                    coordinationLabel.text = "\(coordinate.latitude), \(coordinate.longitude)"
//                    coordinateLatitude = coordinate.latitude
//                    coordinateLongitude = coordinate.longitude
//
//                    let coordinaters = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
//
////                    var latiLongi: [CLLocation] = [CLLocation(latitude: user.latitude!, longitude: user.longitude!)]
//                    let latiLongi = CLLocation(latitude: user.latitude!, longitude: user.longitude!)
//
//                    let radiusComp = user.radius!
//
//                    let distance = coordinaters.distance(from: latiLongi)
//
//                    if distance <= 25 {
//                        if distance <= radiusComp {
//                            print("Handwerker ist innerhalb von 25km -> \(distance)")
//                        } else {
//                            print("Du bist zu weit weg f. Handwerker -> \(distance)")
//                        }
//                    } else {
//                        print("Handwerker ist zu weit weg -> \(distance)")
//                    }
//                }
//            }
//        }
    }
    
    func loadTheUsers() {
        UserApi.shared.observeUsers { (id) in
            self.company.append(id)
        }
    }
    
    func loadAllUsers() {
        UserApi.shared.observeUsers { (userId) in
//            print("userUid ->", self.userUid)
            self.userUid = userId.uid!
//            print("userUid 2.0 ->", self.userUid)
            
//            guard let ZipCodeTwo = userId.countryCode else { return }
//            self.userZipCode.append(contentsOf: [ZipCodeTwo])
            
            if userId.countryCode?.count == 5 {
                self.userZip = userId.countryCode!
                self.userZipCode.append(contentsOf: [self.userZip])
                self.id = userId.uid!
                self.userUidArray.append(contentsOf: [self.id])
            }
            
            // prüfen der IF Anweisung - keine funktion wenn erste ID mit latLong ist
            if userId.latitude != nil && userId.longitude != nil {
                print("-----latitude \(userId.latitude)")
                print("-----latitude \(userId.longitude)")
//                print("userId-----uid", userId.uid)
                self.latLong.append(.init(latitude: userId.latitude!, longitude: userId.longitude!))
                
                self.radiusUs.append(userId.radius!)
                print("plz \(userId.countryCode) -- longLat -- \(userId.latitude) ++ \(userId.longitude) -- radius \(userId.radius)")
            }
            
            
//            print("ZipCode ->", self.userZipCode, "&&  Uid ->",self.userUid)
//            print("userUid ->", self.userUid)
        }
    }
    
    func allUserCoordinate() {
        print("funktoiner allUserCoordinate")
//        for index in userZipCode {
////            index.self
////            print("index how much ////", index.self)
//            let test5 = index
//            print("index how much ////", test5)
//            geocoderUserUid.geocodeAddressString(test5) { (placemarks, error) in
////                print("index geo query ->->->", index.self)
//                print("index geo query ->->->", test5)
//                self.processResponeUserUid(withPlacemarks: placemarks, error: error)
//        //              self.setupLocation()
//                print("userZipCode")
//            }
//            continue
//            print("test20000", index.self)
//        }
        
        // for index and geo while loop -> second try
//        for index in userZipCode {
//            let coorLatLong = index
//            print("zipCodes -> -> ", coorLatLong)
//            zipCounter = userZip.count
//            var counter = 0
//            while (counter < zipCounter) {
//                print("wie oft noch ----- 1")
//                geocoderUserUid.geocodeAddressString(coorLatLong) { (placemarks, error) in
//                    print("how much loops -> ->", coorLatLong)
//                    self.processResponeUserUid(withPlacemarks: placemarks, error: error)
//                }
//                counter += 1
//            }
//        }
        
    }
    
    func setupLocation() {
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
////            let coordinate = coordination
//            let radius = 25000.0
//            let title = "test5000"
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinationLatitude, longitude: coordinationlongitude), radius: radius, identifier: title)
//            locationManager.startMonitoring(for: region)
//            print("region test ->", region)
//        } else {
//            print("---geht nicht---")
//        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        print("zip Button")
        let geoCoder = CLGeocoder()
        
        let street = "Frankenstr. 32"
        let city = "96146"
        let country = "Deutschland"
        let testZipCode = "\(street), \(city), \(country)"
        
        
        geoCoder.geocodeAddressString(testZipCode) { (placemarks, error) in
            guard let placemarks = placemarks?.first else { return }
            let location = placemarks.location?.coordinate ?? CLLocationCoordinate2D()
            guard let urlAppleMaps = URL(string: "http://maps.apple.com/?daddr=\(location.latitude),\(location.longitude)") else { return }
            
            
            guard let urlGoogleMaps = URL(string: "comgooglemaps://?saddr=\(location.latitude),\(location.longitude)&directionsmode=driving") else { return }
            
            
            let alert = UIAlertController(title: "Karte wählen", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
            
            let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) { (action) in
                UIApplication.shared.open(urlAppleMaps)
            }
            
            let googleMaps = UIAlertAction(title: "Google Maps", style: .default) { (action) in
                UIApplication.shared.open(urlGoogleMaps)
            }
            
            alert.addAction(appleMaps)
            alert.addAction(googleMaps)
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
//        guard let zipCode = zipTextField.text else { return }
//        print("\(zipCode)")
//
////        for index in userZipCode {
////            index.self
////            geocoder.geocodeAddressString(index) { (placemarks, error) in
////                self.processResponse(withPlacemarks: placemarks, error: error)
//////                self.setupLocation()
////                print("userZipCode")
////            }
////            print("test20000", index.self)
////        }
//
//
//        let address = zipCode
////        loadAllUsers()
//
//
//
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//            print("CLLocation Manager ZipVC funtzt")
//            self.processResponse(withPlacemarks: placemarks, error: error)
////            self.setupLocation()
//            print("address V1")
//        }
//
//
//
//        print("test 4711")
//
//        print("ZipCode in GPS ->", self.userZipCode)
//        geocoder.geocodeAddressString(userZipCode) { (placemarks, error) in
//            self.processResponse(withPlacemarks: placemarks, error: error)
//            self.setupLocation()
//            print("userZipCode")
//        }
        
        
    }
    
    private func processResponeUserUid(withPlacemarks placemark: [CLPlacemark]?, error: Error?) {
        print("funktioner UserUid Koor. abfrage")
        
        if let error = error {
            coordinationLabel.text = "Adresse nicht gefunden"
        } else {
            var location: CLLocation?
            if let placemarks = placemark, placemarks.count > 0 {
                location = placemarks.first?.location
            }
                    
            if let location = location {
                let coordinate = location.coordinate
                
                coordinateLatitude = coordinate.latitude
                coordinateLongitude = coordinate.longitude
                        
                print("alle users -> \(coordinate.latitude), \(coordinate.longitude)")
            } else {
                coordinationLabel.text = "kein Ort gefunden"
            }
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            coordinationLabel.text = "Adresse nicht gefunden"
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                coordinationLabel.text = "\(coordinate.latitude), \(coordinate.longitude)"
                
                // test for radius
                coordinatesLatitude = coordinate.latitude
                coordinatesLongitude = coordinate.longitude
                
                let cordinaters = CLLocation(latitude: coordinatesLatitude, longitude: coordinatesLongitude)
                
//                let coorAllUser = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
                
//                let distancer = cordinaters.distance(from: coorAllUser) / 1000
                
//                print("distanz", distancer)
//                if (distancer <= 25) {
//                    print("Handwerker ist innerhalb von 25km -> \(distancer)")
//                } else if (distancer >= 25){
//                    print("Handwerker ist zu weit weg -> \(distancer)")
//                }
                
                // TEST normal
//                for indexCorr in latLong {
//                    let distancer = cordinaters.distance(from: indexCorr) / 1000
//                    if (distancer <= 25) {
//                        print("Handwerker ist innerhalb von 25km -> \(distancer)")
//                    } else if (distancer >= 25){
//                        print("Handwerker ist zu weit weg -> \(distancer)")
//                    }
//                }
                
                // ENDE
                
//                for indexCor in latLong {
//                    let distancer = cordinaters.distance(from: indexCor) / 1000
//                    if distancer <= 25 {
//                        print("Handwerker ist innerhalb von 25km -> \(distancer)")
//                    } else {
//                        print("Handwerker ist zu weit weg -> \(distancer)")
//                    }
//                }
                
                
                for index in company {
                    if index.latitude != nil && index.longitude != nil {
                        let latiLongi = CLLocation(latitude: index.latitude!, longitude: index.longitude!)

                        let radiusComp = index.radius!

                        let distance = cordinaters.distance(from: latiLongi) / 1000

                        if distance <= 50 {
                            if distance <= radiusComp || radiusComp == 0 {
                                print("radiusComp -----", radiusComp)
                                print("Handwerker ist innerhalb von 50km -> \(distance) ++ \(index.email!)! ++ \(index.countryCode!)")
                            } else {
                                print("Du bist zu weit weg f. Handwerker -> \(distance) -- \(index.email!) ++ \(index.countryCode!)")
                            }
                        } else {
                            print("Handwerker ist zu weit weg -> \(distance) ++ \(index.email!) ++ \(index.countryCode!)")
                            
                        }
                    }
                }
                
                
                
                
                
                
                
                print("Textfeld -> \(coordinate.latitude), \(coordinate.longitude)")
            } else {
                coordinationLabel.text = "kein Ort gefunden"
            }
        }
    }
    

}
