//
//  ViewController.swift
//  Instagrid
//
//  Created by Marques Lucas on 18/12/2018.
//  Copyright © 2018 Marques Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLayout: LayoutView!
    @IBOutlet var layoutSelecter: [UIButton]!
    
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainLayout.layout = .layoutOne
    }
    
    @IBAction func didTapeLayoutSelecter(_ sender: UIButton) {
        switch sender {
        case layoutSelecter[0]:
            mainLayout.layout = .layoutOne
        case layoutSelecter[1]:
            mainLayout.layout = .layoutTwoo
        case layoutSelecter[2]:
            mainLayout.layout = .layoutThree
        default:
            print("erreur")
        }
    }

}

