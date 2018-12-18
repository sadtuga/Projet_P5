//
//  LayoutView.swift
//  Instagrid
//
//  Created by Marques Lucas on 18/12/2018.
//  Copyright © 2018 Marques Lucas. All rights reserved.
//

import UIKit

class LayoutView: UIView {
    
    @IBOutlet private var swipeImage: UIImageView!      // Contains the UIImageView corresponding to the indication for sharing
    @IBOutlet private var label: UILabel!               // Contains the UILabel corresponding to the indication for sharing
    
    @IBOutlet private var gridView: [UIView]!           // Contains the UIView of the main view
    @IBOutlet private var gridButton: [UIButton]!       // Contains the UIButton from the main view
    @IBOutlet private var gridImageView: [UIImageView]! // Contains the UIImageView of the main view
    @IBOutlet private var selected: [UIImageView]!      // Contains the UIImageView of the layout selector button
    
    // Contains the active layout
    var layout: layoutPreset = .layoutOne {
        didSet {
            setLayout(layout)
        }
    }
    
    // Enumeration of the various layout
    enum layoutPreset {
        case layoutOne, layoutTwoo, layoutThree
        
        // Contains a table by layout
        var layoutSet: [Bool] {
            switch self {
            case .layoutOne:
                return [false, false, false, true]
            case .layoutTwoo:
                return [false, true, false, false]
            case .layoutThree:
                return [false, false, false, false]
            }
        }
    }
    
    // Change the layout inside the mainLayout view
    private func setGrid(_ layout: layoutPreset) {
        var cpt: Int = 0
        for i in layout.layoutSet {
            if i != gridButton[cpt].isHidden {
                gridView[cpt].isHidden = i
                gridButton[cpt].isHidden = i
                gridImageView[cpt].isHidden = i
            }
            gridButton[cpt].tag = cpt
            cpt += 1
        }
    }
    
    // Show or hide the image of the selected table
    private func setSelected(index: Int) {
        for i in selected {
            if i.isHidden == false {
                i.isHidden = true
            }
        }
        selected[index].isHidden = false
    }
    
    // Change the layout value according to the received parameter value
    private func setLayout(_ layout: layoutPreset) {
        switch layout {
        case .layoutOne:
            setGrid(layout)
            setSelected(index: 0)
        case .layoutTwoo:
            setGrid(layout)
            setSelected(index: 1)
        case .layoutThree:
            setGrid(layout)
            setSelected(index: 2)
        }
    }
    
    // Assign an UIImageView based on the index received
    func imageAssigned(_ x: Int) -> UIImageView? {
        switch x {
        case 0:
            return gridImageView[0]
        case 1:
            return gridImageView[1]
        case 2:
            return gridImageView[2]
        case 3:
            return gridImageView[3]
        default:
            return nil
        }
    }
    
    // Makes the button pressed transparent
    func hideButton(index: Int) {
        gridButton[index].setImage(nil, for: UIControl.State.normal)
    }
}
