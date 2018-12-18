//
//  LayoutView.swift
//  Instagrid
//
//  Created by Marques Lucas on 18/12/2018.
//  Copyright © 2018 Marques Lucas. All rights reserved.
//

import UIKit

class LayoutView: UIView {
    
    @IBOutlet private var swipeImage: UIImageView!
    @IBOutlet private var label: UILabel!
    
    @IBOutlet private var gridView: [UIView]!
    @IBOutlet private var gridButton: [UIButton]!
    @IBOutlet private var gridImageView: [UIImageView]!
    @IBOutlet private var selected: [UIImageView]!
    
    
    var layout: layoutPreset = .layoutOne {
        didSet {
            setLayout(layout)
        }
    }
    
    enum layoutPreset {
        case layoutOne, layoutTwoo, layoutThree
        
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

    private func setSelected(index: Int) {
        for i in selected {
            if i.isHidden == false {
                i.isHidden = true
            }
        }
        selected[index].isHidden = false
    }
    
    private func setLayout(_ layout: layoutPreset) {
        switch layout {
        case .layoutOne:
            setGrid(layout)
            setSelected(index: 2)
        case .layoutTwoo:
            setGrid(layout)
            setSelected(index: 0)
        case .layoutThree:
            setGrid(layout)
            setSelected(index: 1)
        }
    }
}
