//
//  helpFunctions.swift
//  MapPlaces
//
//  Created by KAK2164 on 09/10/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import FontAwesome_swift

class helpFunctions {
    
    let googleSignInNotificationKey = "googleNotificationKey"
    
    func get_sheet_id(passedURL: String) -> String {
        let removeThis = "https://docs.google.com/spreadsheets/d/"
        
        if passedURL.range(of: removeThis) == nil {
            return ""
        }
        
        let createdArray = (passedURL.replacingOccurrences(of: removeThis, with: "")).components(separatedBy: "/")
        return createdArray[0]
    }
    
    func buttonColors(fixME: UIButton){
        fixME.setTitleColor(HexColor("6f6a5e"), for: .normal)
        fixME.setTitleColor(HexColor("aa98a9"), for: .highlighted)
    }
    
    func buttonFixSettings(fixME: UIButton, titleName: String){
        fixME.setTitle(titleName, for: .normal)
        fixME.setTitleColor(.blue, for: .normal)
        fixME.setTitleColor(.white, for: .highlighted)
        fixME.contentHorizontalAlignment = .center
        fixME.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        fixME.clipsToBounds = true
        fixME.backgroundColor = .clear
        fixME.layer.cornerRadius = 5
        fixME.layer.borderWidth = 0.2
        fixME.layer.borderColor = UIColor.blue.cgColor
    }
    
    func randomFloat(_ min: Double, _ max: Double) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func doubleDigits(_ digitsNO: Double) -> Double {
        return Double(round(100000 * digitsNO)/100000)
    }
    
    func imageWith(name: String, frameS: Int) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: frameS, height: frameS)
        let iconLabel = UILabel(frame: frame)
        iconLabel.textAlignment = .center
        iconLabel.backgroundColor = .clear
        iconLabel.textColor = .red
        iconLabel.font = UIFont.fontAwesome(ofSize: 35)
        iconLabel.text = String.fontAwesomeIcon(code: name)
        
        UIGraphicsBeginImageContext(frame.size)
        if let thisContext = UIGraphicsGetCurrentContext() {
            iconLabel.layer.render(in: thisContext)
            let iconImage = UIGraphicsGetImageFromCurrentImageContext()
            return iconImage
        }
        return nil
    }
    
}
