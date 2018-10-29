//
//  QuizViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    //rounds
    //males/females/both
    var gender: Gender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        nextButton.isEnabled = false
    }

}

