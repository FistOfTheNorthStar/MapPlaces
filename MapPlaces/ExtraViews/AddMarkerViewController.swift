//
//  AddMarkerViewController.swift
//  MapPlaces
//
//  Created by KAK2164 on 27/10/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import CoreData
import UIKit
import ChameleonFramework
import GoogleAPIClientForREST
import GoogleSignIn
import FontAwesome_swift

class AddMarkerViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GIDSignInDelegate {
    
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var titleF: UITextField!
    @IBOutlet weak var SnippetView: UITextView!
    @IBOutlet weak var iconPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    let markerFuncs = AddMarkerUIUX()
    let dbHelp = dbHelper.sharedIns
    let helpF = helpFunctions()
    let pickerData = fontAwesomes()
    var pickedMarker = "none"
    private let service = GTLRSheetsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: screenSize, colors: [HexColor("#a1e7f2")!, HexColor("#bef2e6")!])
        markerFuncs.addMarkerUIFieldEnhancements(latitudeField)
        markerFuncs.addMarkerUIFieldEnhancements(longitudeField)
        markerFuncs.enhanceTextView(SnippetView)
        markerFuncs.enchanceBtn(saveButton)
        latitudeField.addTarget(self, action: #selector(numericValCheck(theTextField:)), for: .editingChanged)
        longitudeField.addTarget(self, action: #selector(numericValCheck(theTextField:)), for: .editingChanged)
        latitudeField.text = String(longitude)
        longitudeField.text = String(latitude)
        iconPicker.dataSource = self
        iconPicker.delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            //GIDSignIn.sharedInstance().signInSilently()
            service.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        longitudeField.text = String(longitude)
        latitudeField.text = String(latitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func numericValCheck(theTextField: UITextField){
        if theTextField.text == nil {
            return
        }
        theTextField.text = markerFuncs.onlyNums(theTextField)
    }
    
    var largestRowNumber_pass: Int16 = -1
    var sheetID_pass = ""
    @IBAction func saveAction(_ sender: Any) {
        
        var largestRow = dbHelp.fetchLargestRow()
        
        // create a new sheet
        if largestRow.rowNo == -1 || largestRow.sheetID == "" || largestRow.sheetID == "none" {
            let mapSheet = GTLRSheets_Spreadsheet.init()
            let propertiesMap = GTLRSheets_SpreadsheetProperties.init()
            propertiesMap.title = "My Map Places"
            mapSheet.properties = propertiesMap
            
            let createSheet = GTLRSheetsQuery_SpreadsheetsCreate.query(withObject: mapSheet)
            
            service.executeQuery(createSheet) { (ticket, result, NSError) in
                //print(ticket)
                //print(result)
                //print(NSError)
                
                if let error = NSError {
                    print(error)
                    self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
                } else {
                    let response = result as! GTLRSheets_Spreadsheet
                    let sheetID = response.spreadsheetId
                    let managedObjectContext = self.dbHelp.persistentContainer.viewContext
                    
                    let myInfo = NSEntityDescription.insertNewObject(forEntityName: "MyTable", into: managedObjectContext) as! MyTable
                    if sheetID == nil || sheetID == "" {
                        print("no sheetid")
                        self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
                    }
                    myInfo.sheetID = sheetID
                    largestRow.sheetID = sheetID!
                    
                    self.dbHelp.saveDatabase(completion: {(success) in
                        if !success {
                            print("saving sheetid to db failed")
                            self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
                        } else {
                            let range = "Sheet1!A1:F1"
                            let values = GTLRSheets_ValueRange.init()
                            values.values = [
                                ["Title", "Longitude", "Latitude", "Icon", "Snippet", "ID"]
                            ]
                            let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: values, spreadsheetId: largestRow.sheetID, range: range)
                           query.valueInputOption = "USER_ENTERED"
                            self.service.executeQuery(query) { (ticket, result, NSError) in
                                if let error = NSError {
                                    print(error)
                                    self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
                                } else {
                                    largestRow.rowNo = 1
                                    self.addNewMarker(largestRow.rowNo, largestRow.sheetID)
                                }
                            }
                        }
                    })
                }
            }
        } else {
                //this is a bit funny, but the logic was that if 0, the table has been created, but no rows
                if largestRow.rowNo == 0 {
                    largestRow.rowNo = 1
                }
            addNewMarker(largestRow.rowNo, largestRow.sheetID)
        }
    }
    
    func addNewMarker(_ rowNo: Int16, _ sheetId: String) {
        
        let rowNoP1 = rowNo + 1
        let rowNoString = String(rowNoP1)
        //add the info to your own Sheet
        let range = "Sheet1!A" + rowNoString + ":F" + rowNoString
        let values = GTLRSheets_ValueRange.init()
        
        if let longitudeTMPtxt = longitudeField.text {
            if let longitudeTMP = Double(longitudeTMPtxt) {
                longitude = longitudeTMP
            }
        }
        
        if let latitudeTMPtxt = latitudeField.text {
            if let latitudeTMP = Double(latitudeTMPtxt) {
                latitude = latitudeTMP
            }
        }
        
        var passTitle = "n/a"
        if let titleTMP = titleF.text {
            if titleTMP != "" {
                passTitle = titleTMP
            }
        }
        
        var snippet = "n/a"
        if let snippetTMP = SnippetView.text {
            if snippetTMP != "" {
                snippet = snippetTMP
            }
        }
        
        values.values = [
            [passTitle, longitude, latitude, pickedMarker, snippet, rowNo]
        ]
        let query = GTLRSheetsQuery_SpreadsheetsValuesUpdate.query(withObject: values, spreadsheetId: sheetId, range: range)
        query.valueInputOption = "USER_ENTERED"
        service.executeQuery(query) { (ticket, result, NSError) in
            if let error = NSError {
                print(error)
                self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
            } else {
                if !self.saveDB(sheetId, rowNo){
                    print("error saving the new marker to db")
                }
                self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
            }
        }
        
        
    }
    
    func saveDB(_ sheetID: String, _ largestRow: Int16) -> Bool {
        
        if sheetID == "" || sheetID == "none" {
            return false
        }
        
        let managedObjectContext = dbHelp.persistentContainer.viewContext
        let location = NSEntityDescription.insertNewObject(forEntityName: "MarkerLists", into: managedObjectContext) as! MarkerListsMO
        if titleF.text != "" {
            location.title = titleF.text!
        } else {
            location.title = "N/A"
        }
        
        if let longitudeTMP = Double(longitudeField.text!) {
            location.longitude = longitudeTMP
        } else {
            location.longitude = helpF.randomFloat(-180, 180)
        }
        
        if let latitudeTMP = Double(latitudeField.text!) {
            location.latitude = latitudeTMP
        } else {
            location.latitude = helpF.randomFloat(-180, 180)
        }
        
        location.sheetID = sheetID
        location.icon = pickedMarker
        
        if SnippetView.text != "" {
            location.snippet = SnippetView.text!
        } else {
            location.snippet = "n/a"
        }
        
        if largestRow == -1 {
            return false
        }
        
        location.rowNo = largestRow + 1
        var successOrNot = false
        
        dbHelp.saveDatabase(completion: {(success) in
            if !success {
                successOrNot = false
            } else {
                successOrNot = true
            }
        })
        
        return successOrNot
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textInView = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let noOfChars = textInView.count
        return noOfChars < 160
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.fontaAwesomeStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let faHolder = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 40))
        let faLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 30))
        faLabel.textAlignment = .center
        
        let tempPick = pickerData.fontaAwesomeStrings[row]
        if tempPick == "none" {
            faLabel.text = "none"
            faHolder.addSubview(faLabel)
        } else {
            
            faLabel.font = UIFont.fontAwesome(ofSize: 17)
            faLabel.text = String.fontAwesomeIcon(code: tempPick)
            faHolder.addSubview(faLabel)
        }

        return faHolder
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData.fontaAwesomeStrings[row])
        pickedMarker = pickerData.fontaAwesomeStrings[row]
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            
            self.service.authorizer = nil
            self.performSegue(withIdentifier: "backToMapFromAddMarker", sender: self)
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
        }
        
    }
}
