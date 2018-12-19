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
    
    // Returns the index of the image according to the received parameter
    private func indexSelected(layout: Int) -> Int {
        var cpt: Int = 0
        while cpt < selected.count {
            if selected[cpt].tag == layout {
                return cpt
            }
            cpt += 1
        }
        return -1
    }
    
    // Change the layout value according to the received parameter value
    private func setLayout(_ layout: layoutPreset) {
        var value: Int = 0
        switch layout {
        case .layoutOne:
            setGrid(layout)
            value = indexSelected(layout: 0)
            setSelected(index: value)
        case .layoutTwoo:
            setGrid(layout)
            value = indexSelected(layout: 1)
            setSelected(index: value)
        case .layoutThree:
            setGrid(layout)
            value = indexSelected(layout: 2)
            setSelected(index: value)
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
    
    // Modify the image and the label indicating in which way swipe
    func setShareIndication(orientation: UIDeviceOrientation) {
        switch orientation {
        case .portrait:
            swipeImage.image = #imageLiteral(resourceName: "Swipe Up")
            label.text = "Swipe up to share"
        case .landscapeLeft, .landscapeRight:
            swipeImage.image = #imageLiteral(resourceName: "Swipe Left")
            label.text = "Swipe left to share"
        default:
            break
        }
    }
    
    // Reset the main view
    func resetMainLayout() {
        var cpt: Int = 0
        while cpt < gridView.count {
            gridButton[cpt].setImage(#imageLiteral(resourceName: "Plus"), for: UIControl.State.normal)
            gridImageView[cpt].image = nil
            cpt += 1
        }
    }
}
