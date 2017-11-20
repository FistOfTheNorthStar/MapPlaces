//
//  AddMarkerUI.swift
//  MapPlaces
//
//  Created by KAK2164 on 06/11/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import Foundation

class AddMarkerUIUX {
    
    //uitextfield enhancements
    func addMarkerUIFieldEnhancements(_ fields: UITextField){
        fields.layer.cornerRadius = 5
        fields.layer.borderWidth = 0.5
        fields.clipsToBounds = true
    }
    
    //textview
    func enhanceTextView(_ textViewAddMark: UITextView){
        textViewAddMark.layer.cornerRadius = 5
        textViewAddMark.layer.borderColor = UIColor.black.cgColor
        textViewAddMark.layer.borderWidth = 0.5
        textViewAddMark.clipsToBounds = true
    }
    
    //save btn
    func enchanceBtn(_ saveBtn: UIButton){
        saveBtn.layer.borderWidth = 0.5
        saveBtn.clipsToBounds = true
        saveBtn.layer.borderColor = UIColor.black.cgColor
        saveBtn.setTitleColor(UIColor .gray, for: UIControlState.highlighted)
        saveBtn.setTitleColor(UIColor .black, for: UIControlState.normal)
        saveBtn.addTarget(self, action: #selector(highlightedBorder(btnBorder:)), for: .touchDown)
        saveBtn.addTarget(self, action: #selector(highlightedBorder(btnBorder:)), for: .touchUpInside)
    }
    
    //color change for border on highlight
    @objc func highlightedBorder(btnBorder: UIButton){
        btnBorder.layer.borderColor = UIColor.gray.cgColor
    }
    
    //fun with loops
    func onlyNums(_ textFieldVal: UITextField) -> String {
        if textFieldVal.text == nil {
            return ""
        }
        var returnedString = ""
        let stringArray = Array(textFieldVal.text!)
        let allowedArray = Array(".0123456789")
        for rightChar in stringArray {
            testingChars: for allowedChar in allowedArray {
                if rightChar == allowedChar {
                    returnedString.append(rightChar)
                    break testingChars
                }
            }
        }
        return returnedString
    }
    
}
