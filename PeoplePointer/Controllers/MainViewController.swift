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
    @IBOutlet weak var editPeopleButton: UIButton!
    @IBOutlet weak var roundsSegmentedControl: UISegmentedControl!
    
    var gender: Gender = .random
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameButton.setBackgroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .disabled)
        
        loadPersonLists()
        updateNewGameButtonAvailabiltiy()
    }
    
    //========================================
    // MARK: - Actions
    //========================================
    
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
        guard let sender = sender as? UIButton else { return }

        switch sender {
        case newGameButton:
            guard let destination = segue.destination as? QuizViewController else {fatalError("Unexpected Segue Destination")}
            
            destination.gender = gender
            
            switch roundsSegmentedControl.selectedSegmentIndex {
            case 0:
                switch gender {
                case .random:
                    destination.maxRounds = maleList.count + femaleList.count
                case .male:
                    destination.maxRounds = maleList.count
                    return
                case .female:
                    destination.maxRounds = femaleList.count
                    return
                }
                
            case 1:
                destination.maxRounds = 15
            case 2:
                destination.maxRounds = 10
            case 3:
                destination.maxRounds = 5
            default:
                fatalError("Unknown SegmentedControl Index")
            }

        case editPeopleButton:
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? PersonListsTableViewController else { fatalError("Unexpected Segue Destination") }
            
            destination.gender = .male
            destination.navigationItem.title = "Male People"
            
        default:
            fatalError("Unexpected segue sender")
        }
    }
    
    @IBAction  func unwindToMainViewController(sender: UIStoryboardSegue) {
        updateNewGameButtonAvailabiltiy()
    }
    
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "quizSegue", sender: sender)
    }
    
    @IBAction func editPeopleButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "peopleListSegue", sender: sender)
    }
    
    //========================================
    //MARK: - Custom Functions
    //========================================
    
    fileprivate func updateNewGameButtonAvailabiltiy() {
        var rounds: Int
        
        switch roundsSegmentedControl.selectedSegmentIndex {
        case 0:
            switch gender {
            case .random:
                newGameButton.isEnabled = maleList.count > 3 && femaleList.count > 3
                return
            case .male:
                newGameButton.isEnabled = maleList.count > 3
                return
            case .female:
                newGameButton.isEnabled = femaleList.count > 3
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
