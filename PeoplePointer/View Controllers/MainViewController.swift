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
    
    @IBOutlet weak var roundsSegmentedControl: UISegmentedControl!
    
    var gender: Gender = .random
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        loadPersonLists()
        updateNewGameButtonAvailabiltiy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkBoxesTapped(_ sender: UITapGestureRecognizer) {
        if sender == randomTapGesture {
            
            gender = .random
            randomCheckBox.image = UIImage(named: "Checked")
            boysCheckBox.image = UIImage(named: "Unchecked")
            girlsCheckBox.image = UIImage(named: "Unchecked")
            updateNewGameButtonAvailabiltiy()
            
        } else if sender == malesTapGesture {
            
            gender = .male
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Checked")
            girlsCheckBox.image = UIImage(named: "Unchecked")
            updateNewGameButtonAvailabiltiy()
            
        } else if sender == femalesTapGesture {
            
            gender = .female
            randomCheckBox.image = UIImage(named: "Unchecked")
            boysCheckBox.image = UIImage(named: "Unchecked")
            girlsCheckBox.image = UIImage(named: "Checked")
            updateNewGameButtonAvailabiltiy()
        }
        
    }
    
    @IBAction func roundsSegmentedControlChanged(_ sender: UISegmentedControl) {
        updateNewGameButtonAvailabiltiy()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let sender = sender as? UIButton else {return}
        
        switch sender {
            
        case newGameButton:
            guard let destination = segue.destination as? QuizViewController else {fatalError("Unexpected Segue Destination")}
            
            destination.gender = gender
            
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
    
    @IBAction  func unwindToMainViewController(segue: UIStoryboardSegue) {
        updateNewGameButtonAvailabiltiy()
    }
    
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "quizSegue", sender: sender)
    }
    
    
    @IBAction func editPeopleButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "peopleListSegue", sender: sender)
    }
    
    fileprivate func updateNewGameButtonAvailabiltiy() {
        var rounds: Int
        
        switch roundsSegmentedControl.selectedSegmentIndex {
            
        case 0:
            switch gender {
            case .random:
                newGameButton.isEnabled = maleList.count + femaleList.count > 0
                return
            case .male:
                newGameButton.isEnabled = maleList.count > 0
                return
            case .female:
                newGameButton.isEnabled = femaleList.count > 0
                return
            }
            
        case 1:
            rounds = 15
        case 2:
            rounds = 10
        case 3:
            rounds = 5
        default:
            fatalError("Unknown SegmentedControl Index")
        }
        
        switch gender {
        case .random:
            newGameButton.isEnabled = maleList.count + femaleList.count >= rounds
        case .male:
            newGameButton.isEnabled = maleList.count >= rounds
        case .female:
            newGameButton.isEnabled = femaleList.count >= rounds
        }
    }
    
}
