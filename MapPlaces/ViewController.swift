//
//  ViewController.swift
//  MapPlaces
//
//  Created by KAK2164 on 04/10/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import PopupDialog
import FontAwesome_swift
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GIDSignInDelegate {
    
    private let scopes = [kGTLRAuthScopeSheetsDrive, kGTLRAuthScopeSheetsSpreadsheets]
    var mapView: GMSMapView?
    let locationMgr = CLLocationManager()
    var latitudeS: CLLocationDegrees = 52.5112
    var longitudeS: CLLocationDegrees = 13.4433
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
    let helpF = helpFunctions()
    let dbHelp = dbHelper()
    var coreD = dbHelper.sharedIns
    var dataLocations: [MarkerListsMO] = []
    var setThisLocation = false
    var latitudePass: CLLocationDegrees = 52.5112
    var longitudePass: CLLocationDegrees = 13.4433
    
    let markerIcon = UIButton.init(type: .custom)
    let settingsIcon = UIButton.init(type: .custom)
    let buttonLoc = UIButton.init(type: .custom)
    let questionIcon = UIButton.init(type: .custom)
    let searchIcon = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let camera = GMSCameraPosition.camera(withLatitude: 52.5112, longitude: 13.4433, zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.delegate = self
        view = mapView
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        
        //assign buttons to navigationbar
        iconsForButton(nameFontAwesome: "fa-crosshairs", selector: #selector(ViewController.myLocB), theButton: buttonLoc)
        iconsForButton(nameFontAwesome: "fa-search", selector: #selector(ViewController.autofiller), theButton: searchIcon)
        iconsForButton(nameFontAwesome: "fa-question-circle-o", selector: #selector(ViewController.question), theButton: questionIcon)
        iconsForButton(nameFontAwesome: "fa-gear", selector: #selector(ViewController.segueSettings), theButton: settingsIcon)
        iconsForButton(nameFontAwesome:  "fa-map-pin", selector: #selector(ViewController.addMarkers), theButton: markerIcon)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchIcon)
        
        //add the navbuttons
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: questionIcon), UIBarButtonItem(customView: settingsIcon), UIBarButtonItem(customView: buttonLoc), UIBarButtonItem(customView: markerIcon)]
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        if status == .denied || status == .restricted {
            popup()
            return
        }
        
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
        dataLocations = coreD.fetchAllResults()
        initMarkers(dataLocations)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func segueSettings(){
        
        toggleSetLocationIcon(false)
        self.performSegue(withIdentifier: "toSettings", sender: self)
    }

    @objc func autofiller() {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        toggleSetLocationIcon(false)
        present(acController, animated: true, completion: nil)
    }
    
    @objc func question() {
        toggleSetLocationIcon(false)
        self.performSegue(withIdentifier: "question", sender: self)
    }
    
    //WRAPPER NOT FINISHED, AND WON'T BE FOR THE FIRST VERSION
    //THIS COULD POTENTIALLY BE USED FOR SERVERSIDE CALLS
    /*
     let strURL = "YOUR_URL"
     
     AFWrapper.requestGETURL(strURL, success: {
     (JSONResponse) -> Void in
     print(JSONResponse)
     }) {
     (error) -> Void in
     print(error)
     }
     */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let currentLocation = locations.last!
        //print("Current location: \(currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestLocation()
        case .authorizedWhenInUse:
            myLocation(searchBool: true)
        // Do your thing here
        default:
            print("authorization process end")
            // Permission denied, do something else
        }
    }
    
    @objc func myLocB(){
        myLocation(searchBool: true)
        toggleSetLocationIcon(false)
    }
    
    //This method will call when you press button.
    func myLocation(searchBool: Bool) {
        
        var coordS = CLLocationCoordinate2D(latitude: latitudeS, longitude:longitudeS)
        
        if searchBool {
            
            //testing that permissions have been given
            let status  = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                locationMgr.requestWhenInUseAuthorization()
                return
            }
            if status == .denied || status == .restricted {
                popup()
                return
            }
            
            if locationMgr.location?.coordinate != nil {
                coordS = locationMgr.location!.coordinate
            } 
        }
      
        mapView?.camera = GMSCameraPosition.camera(withTarget: coordS, zoom: zoomLevel)
        
    }
    
    func popup(){
        let title = "LOCATION DISABLED"
        let message = "Please enable Location Services in Settings"
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        // Create buttons
        let buttonOK = CancelButton(title: "OK") {
            print("You got the message.")
        }
        popup.addButtons([buttonOK])
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func addMarkers(){
       
        toggleSetLocationIcon(true)
    }
    
    func toggleSetLocationIcon(_ addMarkerOrOther: Bool){
        
        if !setThisLocation && addMarkerOrOther {
            markerIcon.setTitleColor(.red, for: .normal)
            setThisLocation = true
        } else {
            markerIcon.setTitleColor(.darkGray, for: .normal)
            setThisLocation = false
        }
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: questionIcon), UIBarButtonItem(customView: settingsIcon), UIBarButtonItem(customView: buttonLoc), UIBarButtonItem(customView: markerIcon)]
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if !setThisLocation {
            return
        }
        
        latitudePass = coordinate.latitude
        longitudePass = coordinate.longitude
        setThisLocation = false
        toggleSetLocationIcon(false)
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() && GIDSignIn.sharedInstance().currentUser != nil {
            self.performSegue(withIdentifier: "addMarkers", sender: self)
        } else {
            self.performSegue(withIdentifier: "toSettings", sender: self)

        }
    }
    
    func initMarkers(_ markerList: [MarkerListsMO]){
        if markerList.count == 0 {
            return
        }
        for markerTMP in markerList {
            let position = CLLocationCoordinate2D(latitude: markerTMP.latitude, longitude: markerTMP.longitude)
            let marker = GMSMarker(position: position)
            marker.title = markerTMP.title
            marker.snippet = markerTMP.snippet
            if markerTMP.icon != "none" && markerTMP.icon != "" {
                let iconIMG = helpF.imageWith(name:  markerTMP.icon!, frameS: 50)!
                marker.icon = iconIMG
            }
            marker.map = mapView
        }
    }

    //not needed
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMarkers" {
            if let addMarkerView = segue.destination as? AddMarkerViewController {
                addMarkerView.longitude = longitudePass
                addMarkerView.latitude = latitudePass
            }
        }
    }
}

extension ViewController {
    
    func iconsForButton(nameFontAwesome: String, selector: Selector, theButton: UIButton){
        //assign button to navigationbar
        theButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17)
        theButton.setTitle(String.fontAwesomeIcon(code: nameFontAwesome), for: .normal)
        //add function for button
        theButton.addTarget(self, action: selector, for: UIControlEvents.touchUpInside)
        //set frame
        theButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        helpF.buttonColors(fixME: theButton)
    }
    
}
