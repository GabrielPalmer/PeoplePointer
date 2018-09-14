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
    
    @IBOutlet var boysTapGesture: UITapGestureRecognizer!
    @IBOutlet var girlsTapGesture: UITapGestureRecognizer!
    @IBOutlet var randomTapGesture: UITapGestureRecognizer!
    
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
        if sender == randomTapGesture {
            
            radioArray[0] = false
            radioArray[1] = true
            radioArray[2] = false
            randomCheckBox.image = UIImage(named: "Checked")
            boysCheckBox.image = UIImage(named: "Unchecked")
            girlsCheckBox.image = UIImage(named: "Unchecked")
            
            
        } else if sender == boysTapGesture {
            
            radioArray[0] = false
            radioArray[1] = true
            radioArray[2] = false
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Checked")
            girlsCheckBox.image = UIImage(named: "Unchecked")
            
        } else if sender == girlsTapGesture {
            
            radioArray[0] = false
            radioArray[1] = false
            radioArray[2] = true
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Unchecked")
            girlsCheckBox.image = UIImage(named: "Checked")
        }
        
    }
    
}

