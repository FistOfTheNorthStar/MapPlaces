//
//  File.swift
//  MapPlaces
//
//  Created by KAK2164 on 09/10/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import ChameleonFramework
import SnapKit
import PopupDialog
import Messages
import CoreData

class SettingsViewController: MSMessagesAppViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let scopes = [kGTLRAuthScopeSheetsDrive, kGTLRAuthScopeSheetsSpreadsheets]
    let helpF = helpFunctions()
    let info_text = UILabel()
    let googleButton = GIDSignInButton()
    let googleSignoutButton = UIButton()
    let box = UIView()
    let locationTableView: UITableView = UITableView()
    let scroller = UIScrollView()
    //this is the container for the signin button
    let googleView = UIView()
    let googleViewOut = UIView()
    let infoField = UILabel()
    let inputField = UITextField()
    let inputButton = UIButton()
    private let service = GTLRSheetsService()
    let dbHelp = dbHelper.sharedIns
    var tempSheetID = ""
    var dataLocations: [MarkerListsMO] = []
    let cellBetHeight: CGFloat = 5
    var lastRowNo: Int16 = 0
    var sheetID: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let buttonSize = CGRect(x: 0, y: 0, width: 200, height: 40)
        view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: screenSize, colors: [HexColor("#DDD8D1")!, HexColor("#f9fbff")!])
        
        //init text
        infoField.textAlignment = .center
        infoField.font = infoField.font.withSize(13)
        info_text.textAlignment = .center
        info_text.font = info_text.font.withSize(13)
        
        self.title = NSLocalizedString("settings.title", comment: "")
        let navBarSize = self.navigationController?.navigationBar.bounds
        self.navigationController?.navigationBar.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: navBarSize!, colors: [HexColor("#d9d9d9")!, HexColor("#f5f5f5")!])
        //let doneBItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(backB))
        let doneBItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backB))
        
        self.navigationItem.rightBarButtonItem = doneBItem
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if GIDSignIn.sharedInstance().currentUser == nil {
            GIDSignIn.sharedInstance().signOut()
        }
        
        //google signin
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().uiDelegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() && GIDSignIn.sharedInstance().currentUser != nil {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
        
        //let's add all the buttons to a nice looking box
        view.addSubview(scroller)
        scroller.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        view.addSubview(box)
        box.layer.cornerRadius = 6
        box.layer.masksToBounds = true
        box.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scroller).offset(0)
            make.left.equalTo(scroller).offset(0)
            make.bottom.equalTo(scroller).offset(0)
            make.right.equalTo(scroller).offset(0)
        }
        
        box.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: screenSize, colors: [HexColor("#d9d9d9")!, HexColor("#f5f5f5")!])
        box.layer.borderWidth = 1
        box.layer.borderColor = HexColor("cfcfcf")?.cgColor
        box.addSubview(info_text)
        info_text.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(10)
            make.left.equalTo(box).offset(10)
            make.height.equalTo(30)
            make.right.equalTo(box).offset(-10)
        }
        
        googleButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        googleView.addSubview(googleButton)
        box.addSubview(googleView)
        googleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(50)
            make.width.equalTo(200)
            make.centerX.equalTo(box)
            make.height.equalTo(50)
        }
        
        //use this observer to call toggleui after signin
        NotificationCenter.default.addObserver(self, selector: #selector(toggleAuthUI), name: NSNotification.Name(rawValue: helpF.googleSignInNotificationKey), object: nil)
        
        //add the signout button here
        box.addSubview(googleSignoutButton)
        googleSignoutButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(50)
            make.size.equalTo(CGSize(width: 200, height: 40))
            make.centerX.equalTo(box)
        }
       
        googleSignoutButton.setBackgroundColor(color: GradientColor(UIGradientStyle.topToBottom, frame: buttonSize, colors: [HexColor("#fcc9d3")!, HexColor("#f75e7a")!]), forState: .highlighted)
        
        googleSignoutButton.addTarget(self, action: #selector(SettingsViewController.didTapSignOut), for: UIControlEvents.touchUpInside)
        helpF.buttonFixSettings(fixME: googleSignoutButton, titleName: NSLocalizedString("settings.logout", comment: ""))
        
        //add input field, label for it and button to submit
        box.addSubview(infoField)
        infoField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(100)
            make.left.equalTo(box).offset(10)
            make.height.equalTo(30)
            make.right.equalTo(box).offset(-10)
        }
        
        box.addSubview(inputField)
        inputField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(130)
            make.height.equalTo(40)
            make.centerX.equalTo(box)
            make.width.equalTo(200)
        }
        
        inputField.clipsToBounds = true
        inputField.layer.cornerRadius = 5
        inputField.layer.borderWidth = 0.2
        inputField.layer.borderColor = UIColor.black.cgColor
        inputField.textAlignment = .center
        
        box.addSubview(inputButton)
        inputButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(190)
            make.height.equalTo(40)
            make.centerX.equalTo(box)
            make.width.equalTo(200)
        }
        
        inputButton.setBackgroundColor(color: GradientColor(UIGradientStyle.topToBottom, frame: buttonSize, colors: [HexColor("#f5f4fb")!, HexColor("#d0c9fc")!]), forState: .highlighted)
        inputButton.addTarget(self, action: #selector(SettingsViewController.getSheet), for: UIControlEvents.touchUpInside)
        inputButton.clipsToBounds = true
        inputButton.backgroundColor = .clear
        helpF.buttonFixSettings(fixME: inputButton, titleName: NSLocalizedString("settings.submit", comment: ""))

        locationTableView.dataSource = self
        locationTableView.delegate = self
        box.addSubview(locationTableView)
        locationTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(box).offset(250)
            make.bottom.equalTo(view).offset(-25)
            make.left.equalTo(box).offset(5)
            make.right.equalTo(box).offset(-5)
        }
        
        locationTableView.backgroundColor = nil
        locationTableView.backgroundColor = UIColor.clear
        
        toggleAuthUI()
        
        dataLocations = dbHelp.fetchAllResults()
        locationTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataLocations.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellBetHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor.clear
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        locationTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteLocation = dataLocations[indexPath.row]
        let delRowInt = Int(deleteLocation.rowNo)
        let delRow = String(delRowInt)
        let range = "Sheet1!A" + delRow + ":H" + delRow
        let query = GTLRSheetsQuery_SpreadsheetsValuesClear.query(withObject: GTLRSheets_ClearValuesRequest.init(), spreadsheetId: deleteLocation.sheetID!, range: range)
        
        service.executeQuery(query) { (ticket, result, NSError) in
            self.dbHelp.deleteManagedObject(managedObject: deleteLocation, completion: {(success) in
                if (success){
                    self.dataLocations.remove(at: indexPath.row)
                    self.locationTableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "locationCell")

        cell.textLabel?.text = dataLocations[indexPath.row].title
        cell.backgroundColor = nil
        cell.backgroundColor = UIColor.clear
        cell.clipsToBounds = true
        return cell
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
         NotificationCenter.default.post(name: Notification.Name(rawValue: helpF.googleSignInNotificationKey), object: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc func backB() {
        self.performSegue(withIdentifier: "backToMap", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func didTapSignOut() {
        GIDSignIn.sharedInstance().signOut()
        toggleAuthUI()
    }
    
    @objc func getSheet(){
        
        let spreadsheetURL = inputField.text!
        tempSheetID = helpF.get_sheet_id(passedURL: spreadsheetURL)
        if tempSheetID == "" {
            popup(errorMSG: "Make sure the link is copied correctly from Google Sheets", titleSet: "Sheets Link Error")
            return
        }
        sheetID = tempSheetID
        let range = "Sheet1!A:H"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: tempSheetID, range:range)
        service.executeQuery(query, delegate: self, didFinish: #selector(addResults(ticket:finishedWithObject:error:))
        )
    }
    
    @objc func addResults(ticket: GTLRServiceTicket, finishedWithObject result : GTLRSheets_ValueRange, error : NSError?) {
        
        if let errorTEMP = error?.localizedDescription {
            popup(errorMSG: errorTEMP as String, titleSet: "Google Sheets Error")
            print(errorTEMP)
            return
        }
        
        let rows = result.values!
        if rows.isEmpty {
            return
        }
        print(rows)
        lastRowNo = Int16(rows.count)
        var skipFirst = 0
        for locationR in rows {
            
            if locationR.isEmpty || locationR.count < 6 || skipFirst == 0 {
                skipFirst = 1
                continue
            }
            if !saveToCoreData(locationR) {
                print("Error saving")
                popup(errorMSG: NSLocalizedString("succes.list_saved", comment: ""), titleSet: NSLocalizedString("error.settings_save_title", comment: ""))
                return
            } 
        }
        
    }
    
    func saveToCoreData(_ locationTemp: [Any]) -> Bool {
      
        //weak var location: MarkerListsMO? = dbHelp.createManagedObject(entityName: "MarkerLists") as? MarkerListsMO
        let managedObjectContext = dbHelp.persistentContainer.viewContext
        let location = NSEntityDescription.insertNewObject(forEntityName: "MarkerLists", into: managedObjectContext) as! MarkerListsMO
        
        if let title = locationTemp[0] as? String {
            if title != "" {
                location.title = title
            } else {
                location.title = "N/A"
            }
        } else {
            location.title = "N/A"
        }
        if let longitudeTMP = locationTemp[1] as? String {
            if let longitude = Double(longitudeTMP) {
                location.longitude = longitude
            } else {
                location.longitude = helpF.randomFloat(-180, 180)
            }
        } else {
            return false
        }
        if let latitudeTMP = locationTemp[2] as? String {
            if let latitude = Double(latitudeTMP) {
                location.latitude = latitude
            } else {
                location.latitude = helpF.randomFloat(-180, 180)
            }
        } else {
            return false
        }
        if let icon = locationTemp[3] as? String {
            switch icon {
            case "":
                location.icon = "none"
            default:
                location.icon = icon
            }
        } else {
            location.icon = "none"
        }
        
        if let snippet = locationTemp[4] as? String {
            if snippet != "" {
                location.snippet = snippet
            } else {
                location.snippet = "n/a"
            }
        } else {
            location.snippet = "n/a"
        }
       
        guard sheetID != "" else {
            return true
        }
        location.sheetID = sheetID
        
        if let rowNoTMP = locationTemp[5] as? String {
            if let rowNo = Int16(rowNoTMP) {
                location.rowNo = rowNo
            } else {
                location.rowNo = 1
            }
        } else {
            return false
        }

        var successOrNot = false
        
        dbHelp.saveDatabase(completion: {(success) in
            if !success {
                successOrNot = false
            } else {
                successOrNot = true
                dataLocations.append(location)
                locationTableView.reloadData()
            }
        })
        
        return successOrNot
    }
    
    //call this to set the buttons / text correct
    @objc func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() &&             GIDSignIn.sharedInstance().currentUser != nil {
            googleButton.isHidden = true
            googleView.isHidden = true
            googleSignoutButton.isHidden = false
            googleViewOut.isHidden = false
            info_text.text = NSLocalizedString("settings.signedin", comment: "")
            infoField.isHidden = false
            inputField.isHidden = false
            inputButton.isHidden = false
            infoField.text = NSLocalizedString("settings.fieldinfo", comment: "")
        } else {
            googleButton.isHidden = false
            googleView.isHidden = false
            googleSignoutButton.isHidden = true
            googleViewOut.isHidden = true
            info_text.text = NSLocalizedString("settings.signin", comment: "")
            inputField.isHidden = true
            inputButton.isHidden = true
            infoField.isHidden = true
            inputField.isHidden = true
            self.service.authorizer = nil
            
        }
    }
    
    //clean up
    deinit {
        
    }
    
    func popup(errorMSG: String, titleSet: String){
        
        //let message = "Please enable Location Services in Settings"
        // Create the dialog
        let popup = PopupDialog(title: titleSet, message: errorMSG)
        // Create buttons
        let buttonOK = CancelButton(title: "OK") {
            print("You got the message.")
        }
        popup.addButtons([buttonOK])
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
   
}
