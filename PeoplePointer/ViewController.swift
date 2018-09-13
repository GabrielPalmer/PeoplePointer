//
//  ViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 9/13/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boysCheckBox: UIImageView!
    @IBOutlet weak var girlsCheckBox: UIImageView!
    @IBOutlet weak var randomCheckBox: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var radioArray: [Bool] = [true, false, false]
    
    @IBAction func checkBoxesTapped(_ sender: UITapGestureRecognizer) {
        
    }
}

