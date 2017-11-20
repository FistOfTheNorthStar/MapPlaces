//
//  QuestionViewController.swift
//  MapPlaces
//
//  Created by KAK2164 on 08/11/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import UIKit
import ChameleonFramework

class QuestionViewController: UIViewController {

    let fontSize: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let margins = view.layoutMarginsGuide
        let screenSize: CGRect = UIScreen.main.bounds
        view.backgroundColor = GradientColor(UIGradientStyle.topToBottom, frame: screenSize, colors: [HexColor("#F50A58")!, HexColor("#F50AD5")!])
        
        var layoutGuides: [NSLayoutConstraint] = []
        
        let searchLabel = UILabel()
        searchLabel.font = UIFont.fontAwesome(ofSize: fontSize)
        searchLabel.text = String.fontAwesomeIcon(code: "fa-search")
        view.addSubview(searchLabel)
        let searchLeading = NSLayoutConstraint(item: searchLabel, attribute: .leading, relatedBy: .equal, toItem: margins, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let searchTop = NSLayoutConstraint(item: searchLabel, attribute: .top, relatedBy: .equal, toItem: margins, attribute: .top, multiplier: 1.0, constant: 20)
        layoutGuides.append(searchLeading)
        layoutGuides.append(searchTop)
        
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let searchLabelExplanation = UILabel()
        fixLabel(thisLabel: searchLabelExplanation, fontSize: fontSize, description: "question.search")
        
        let searchEtop = NSLayoutConstraint(item: searchLabelExplanation, attribute: .top, relatedBy: .equal, toItem: margins, attribute: .top, multiplier: 1.0, constant: 20)
        let searchElead = NSLayoutConstraint(item: searchLabelExplanation, attribute: .leading, relatedBy: .equal, toItem: searchLabel, attribute: .trailing, multiplier: 1.0, constant: 20)
        let searchEtrail = NSLayoutConstraint(item: searchLabelExplanation, attribute: .trailing, relatedBy: .equal, toItem: margins, attribute: .trailing, multiplier: 1.0, constant: 0)
        layoutGuides.append(searchEtop)
        layoutGuides.append(searchElead)
        layoutGuides.append(searchEtrail)
        
        let questionMarkLabel = UILabel()
        questionMarkLabel.font = UIFont.fontAwesome(ofSize: fontSize)
        questionMarkLabel.text = String.fontAwesomeIcon(code: "fa-crosshairs")
        questionMarkLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(questionMarkLabel)
        
        let qLeading = NSLayoutConstraint(item: questionMarkLabel, attribute: .leading, relatedBy: .equal, toItem: margins, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let qTop = NSLayoutConstraint(item: questionMarkLabel, attribute: .top, relatedBy: .equal, toItem: searchLabelExplanation, attribute: .bottom, multiplier: 1, constant: 20)
        let qWidth = NSLayoutConstraint(item: questionMarkLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        layoutGuides.append(qLeading)
        layoutGuides.append(qTop)
        layoutGuides.append(qWidth)
        
        let questionMarkLabelExplanation = UILabel()
        fixLabel(thisLabel: questionMarkLabelExplanation, fontSize: fontSize, description: "question.crosshairs")
        
        let qEtop = NSLayoutConstraint(item: questionMarkLabelExplanation, attribute: .top, relatedBy: .equal, toItem: searchLabelExplanation, attribute: .bottom, multiplier: 1.0, constant: 20)
        let qElead = NSLayoutConstraint(item: questionMarkLabelExplanation, attribute: .leading, relatedBy: .equal, toItem: questionMarkLabel,   attribute: .trailing, multiplier: 1.0, constant: 20)
        let qEtrail = NSLayoutConstraint(item: questionMarkLabelExplanation, attribute: .trailing, relatedBy: .equal, toItem: margins, attribute: .trailing, multiplier: 1.0, constant: 0)
        layoutGuides.append(qEtop)
        layoutGuides.append(qElead)
        layoutGuides.append(qEtrail)
        
        let settingsLabel = UILabel()
        settingsLabel.font = UIFont.fontAwesome(ofSize: fontSize)
        settingsLabel.text = String.fontAwesomeIcon(code: "fa-gear")
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsLabel)
        let sLeading = NSLayoutConstraint(item: settingsLabel, attribute: .leading, relatedBy: .equal, toItem: margins, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let sTop = NSLayoutConstraint(item: settingsLabel, attribute: .top, relatedBy: .equal, toItem: questionMarkLabelExplanation, attribute: .bottom, multiplier: 1, constant: 20)
        let sWidth = NSLayoutConstraint(item: settingsLabel, attribute: .width, relatedBy: .equal, toItem: questionMarkLabel, attribute: .width, multiplier: 1, constant: 0)
        layoutGuides.append(sLeading)
        layoutGuides.append(sTop)
        layoutGuides.append(sWidth)
        
        let settingsLabelExplanation = UILabel()
        fixLabel(thisLabel: settingsLabelExplanation, fontSize: fontSize, description: "question.settings")
        
        let sEtop = NSLayoutConstraint(item: settingsLabelExplanation, attribute: .top, relatedBy: .equal, toItem: questionMarkLabelExplanation, attribute: .bottom, multiplier: 1.0, constant: 20)
        let sElead = NSLayoutConstraint(item: settingsLabelExplanation, attribute: .leading, relatedBy: .equal, toItem: settingsLabel,   attribute: .trailing, multiplier: 1.0, constant: 20)
        let sEtrail = NSLayoutConstraint(item: settingsLabelExplanation, attribute: .trailing, relatedBy: .equal, toItem: margins, attribute: .trailing, multiplier: 1.0, constant: 0)
        layoutGuides.append(sEtop)
        layoutGuides.append(sElead)
        layoutGuides.append(sEtrail)
        
        let mapPinLabel = UILabel()
        mapPinLabel.font = UIFont.fontAwesome(ofSize: fontSize)
        mapPinLabel.text = String.fontAwesomeIcon(code: "fa-map-pin")
        mapPinLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapPinLabel)
        let mLeading = NSLayoutConstraint(item: mapPinLabel, attribute: .leading, relatedBy: .equal, toItem: margins, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let mTop = NSLayoutConstraint(item: mapPinLabel, attribute: .top, relatedBy: .equal, toItem: settingsLabelExplanation, attribute: .bottom, multiplier: 1, constant: 20)
        let mWidth = NSLayoutConstraint(item: mapPinLabel, attribute: .width, relatedBy: .equal, toItem: questionMarkLabel, attribute: .width, multiplier: 1, constant: 0)
        layoutGuides.append(mLeading)
        layoutGuides.append(mTop)
        layoutGuides.append(mWidth)
        
        let mapPinLabelExplanation = UILabel()
        fixLabel(thisLabel: mapPinLabelExplanation, fontSize: fontSize, description: "question.mappinpoint")
        
        let mEtop = NSLayoutConstraint(item: mapPinLabelExplanation, attribute: .top, relatedBy: .equal, toItem: settingsLabelExplanation, attribute: .bottom, multiplier: 1.0, constant: 20)
        let mElead = NSLayoutConstraint(item: mapPinLabelExplanation, attribute: .leading, relatedBy: .equal, toItem: mapPinLabel,   attribute: .trailing, multiplier: 1.0, constant: 20)
        let mEtrail = NSLayoutConstraint(item: mapPinLabelExplanation, attribute: .trailing, relatedBy: .equal, toItem: margins, attribute: .trailing, multiplier: 1.0, constant: 0)
        layoutGuides.append(mEtop)
        layoutGuides.append(mElead)
        layoutGuides.append(mEtrail)
        
        NSLayoutConstraint.activate(layoutGuides)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fixLabel(thisLabel: UILabel, fontSize: CGFloat, description: String){
        thisLabel.font = UIFont.systemFont(ofSize: fontSize)
        thisLabel.numberOfLines = 0
        thisLabel.text = NSLocalizedString(description, comment: "")
        thisLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(thisLabel)
    }

}
