//
//  ViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 9/13/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var boysCheckBox: UIImageView!
    @IBOutlet weak var girlsCheckBox: UIImageView!
    @IBOutlet weak var randomCheckBox: UIImageView!
    
    @IBOutlet var randomTapGesture: UITapGestureRecognizer!
    @IBOutlet var malesTapGesture: UITapGestureRecognizer!
    @IBOutlet var femalesTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var editMalesButton: UIButton!
    @IBOutlet weak var editFemalesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersonLists()
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
            
        } else if sender == malesTapGesture {
            
            radioArray[0] = false
            radioArray[1] = true
            radioArray[2] = false
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Checked")
            girlsCheckBox.image = UIImage(named: "Unchecked")
            
        } else if sender == femalesTapGesture {
            
            radioArray[0] = false
            radioArray[1] = false
            radioArray[2] = true
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Unchecked")
            girlsCheckBox.image = UIImage(named: "Checked")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let sender = sender as? UIButton else {return}
        
        switch sender {
        case newGameButton:
            fatalError("Not Implemented")
            
        case editMalesButton:
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? PersonListsTableViewController else {fatalError("Unexpected Segue Destination")}
            
            destination.gender = .male
            destination.navigationItem.title = "Male People"
            
        case editFemalesButton:
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? PersonListsTableViewController else {fatalError("Unexpected Segue Destination")}
            
            destination.gender = .female
            destination.navigationItem.title = "Female People"
            
        default:
            fatalError("Unexpected Segue Indentifier")
        }
    }
    
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "quizSegue", sender: sender)
    }
    
    
    @IBAction func editPeopleButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "peopleListSegue", sender: sender)
    }
    
    
}

