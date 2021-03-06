//
//  QuizViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    //========================================
    // MARK: - Properties
    //========================================
    
    enum QuestionType {
        case singleImage, singleName
    }
    
    //singe Image question view outlets
    @IBOutlet weak var singleImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameButton1: UIButton!
    @IBOutlet weak var nameButton2: UIButton!
    @IBOutlet weak var nameButton3: UIButton!
    @IBOutlet weak var nameButton4: UIButton!
    
    //single name question view outlets
    @IBOutlet weak var singleNameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet var imageTapGesture1: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture2: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture3: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture4: UITapGestureRecognizer!
    
    //general outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var roundProgressBar: UIProgressView!
    
    //placeholder values are just meant to be non-optional and variables will have their true values set later
    var roundFinished: Bool = false
    var questionType : QuestionType = .singleImage //placeholder
    var correctAnswer: Int?
    var round        : Int = 1
    var maxRounds    : Int = 4                     //placeholder
    var amountCorrect: Float = 0
    var gender       : Gender = .random            //placeholder
    var game         : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView1.layer.borderWidth = 10
        imageView2.layer.borderWidth = 10
        imageView3.layer.borderWidth = 10
        imageView4.layer.borderWidth = 10
        imageView1.layer.cornerRadius = 8
        imageView2.layer.cornerRadius = 8
        imageView3.layer.cornerRadius = 8
        imageView4.layer.cornerRadius = 8
        imageView1.clipsToBounds = true
        imageView2.clipsToBounds = true
        imageView3.clipsToBounds = true
        imageView4.clipsToBounds = true
        imageView1.layer.borderColor = UIColor.clear.cgColor
        imageView2.layer.borderColor = UIColor.clear.cgColor
        imageView3.layer.borderColor = UIColor.clear.cgColor
        imageView4.layer.borderColor = UIColor.clear.cgColor
        
        /*
        nameButton1.addBorder(side: .top, thickness: 2, color: .black)
        nameButton1.addBorder(side: .bottom, thickness: 1, color: .black)
        nameButton2.addBorder(side: .top, thickness: 1, color: .black)
        nameButton2.addBorder(side: .bottom, thickness: 1, color: .black)
        nameButton3.addBorder(side: .top, thickness: 1, color: .black)
        nameButton3.addBorder(side: .bottom, thickness: 1, color: .black)
        nameButton4.addBorder(side: .top, thickness: 1, color: .black)
        nameButton4.addBorder(side: .bottom, thickness: 2, color: .black)
        */

        //roundProgressBar.barHeight = 6 //the IB class for this dissapeared
        newGame()
    }
    
    //========================================
    // MARK: - Actions
    //========================================
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if !roundFinished {
            imageView1.layer.borderColor = correctAnswer == imageView1.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView2.layer.borderColor = correctAnswer == imageView2.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView3.layer.borderColor = correctAnswer == imageView3.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView4.layer.borderColor = correctAnswer == imageView4.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            
            if sender.view!.tag == correctAnswer {
                amountCorrect += 1
            }
        }
        
        roundFinished = true
        animateNextButton()
    }
    
    @IBAction func personButtonTapped(_ sender: UIButton) {
        if !roundFinished {
            nameButton1.tintColor = correctAnswer == nameButton1.tag ? UIColor.green : UIColor.red
            nameButton2.tintColor = correctAnswer == nameButton2.tag ? UIColor.green : UIColor.red
            nameButton3.tintColor = correctAnswer == nameButton3.tag ? UIColor.green : UIColor.red
            nameButton4.tintColor = correctAnswer == nameButton4.tag ? UIColor.green : UIColor.red
            
            if sender.tag == correctAnswer {
                amountCorrect += 1
            }
        }
        
        roundFinished = true
        animateNextButton()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if round == maxRounds {
            performSegue(withIdentifier: "resultsSegue", sender: nil)
            return
        }
        
        round += 1
        
        if round == maxRounds {
            nextButton.setTitle("Finish", for: .normal)
        }
        newRound()
    }
    
    //========================================
    // MARK: - Custom Functions
    //========================================
    
    fileprivate func animateNextButton() {
        nextButton.alpha = 0
        nextButton.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.nextButton.alpha = 1
        }
    }
    
    fileprivate func newGame() {
        nextButton.setTitle("Next", for: .normal)
        roundFinished = false
        round = 1
        amountCorrect = 0
        nextButton.isHidden = true
        
        //Game object is reused if retrying set
        if game == nil {
            game = Game(forList: gender)
        }
        
        newRound()
    }
    
    fileprivate func newRound() {
        roundFinished = false
        nextButton.isHidden = true
        
        roundProgressBar.setProgress(Float(round - 1) / Float(maxRounds), animated: true)
    
        if questionType == .singleName {
            imageView1.layer.borderColor = UIColor.clear.cgColor
            imageView2.layer.borderColor = UIColor.clear.cgColor
            imageView3.layer.borderColor = UIColor.clear.cgColor
            imageView4.layer.borderColor = UIColor.clear.cgColor
        } else {
            nameButton1.tintColor = .black
            nameButton2.tintColor = .black
            nameButton3.tintColor = .black
            nameButton4.tintColor = .black
        }

        guard let game = game else { fatalError("game did not exist on newRound()") }

        var correctPerson: Person?
        var personsForRound: [Person] = []
        var randomGender: Gender = .random   //when gender = .random, this must be set to male/female or app will crash

        //gets answer person for round, which is always the first index of personsForRound
        switch gender {
        case .male:
            correctPerson = game.removePersonFromList(gender: .male)
        case .female:
            correctPerson = game.removePersonFromList(gender: .female)
        case .random:

            //check if all names of a list have been used, if so set gender from random to only use remaining list
            if game.remainingPossibleMales.count == 0 {
                gender = .female
                correctPerson = game.removePersonFromList(gender: .female)
                break
            } else if game.remainingPossibleFemales.count == 0 {
                gender = .male
                correctPerson = game.removePersonFromList(gender: .male)
                break
            }

            //gets random person from remaining gender list and ensure the other fill persons will be that gender
            if Bool.random() {
                randomGender = .male
                correctPerson = game.removePersonFromList(gender: .male)
            } else {
                randomGender = .female
                correctPerson = game.removePersonFromList(gender: .female)
            }
        }

        if let correctPerson = correctPerson {

            switch gender {
            case .male:
                game.malesUsed.append(correctPerson)
            case .female:
                game.femalesUsed.append(correctPerson)
            case .random:
                switch randomGender {
                case .male:
                    game.malesUsed.append(correctPerson)
                case .female:
                    game.femalesUsed.append(correctPerson)
                case .random:
                    fatalError("randomGender was still .random after randomization")
                }
            }

            personsForRound.append(correctPerson)
        } else {
            fatalError("correctPerson was still nil after randomization")
        }


        //fills in 3 more persons in personsForRound ensuring no duplicates
        for _ in 0...2 {
            var person: Person!

            switch gender {
            case .male, .female:
                repeat {
                    person = game.getPersonFromList(gender: gender)
                } while personsForRound.contains(person)

            case .random:
                repeat {
                    person = game.getPersonFromList(gender: randomGender)
                } while personsForRound.contains(person)
            }

            personsForRound.append(person!)
        }

        //selects random question type and imageView/label for correct answer
        questionType = Bool.random() ? .singleImage : .singleName
        correctAnswer = Int(arc4random_uniform(4)) + 1

        if questionType == .singleName {

            singleNameView.isHidden = false
            singleImageView.isHidden = true
            nameLabel.text = personsForRound.first?.name

            switch correctAnswer {
            case 1:
                imageView1.image = personsForRound.first?.image
                imageView2.image = personsForRound[1].image
                imageView3.image = personsForRound[2].image
                imageView4.image = personsForRound[3].image
            case 2:
                imageView1.image = personsForRound[1].image
                imageView2.image = personsForRound.first?.image
                imageView3.image = personsForRound[2].image
                imageView4.image = personsForRound[3].image
            case 3:
                imageView1.image = personsForRound[1].image
                imageView2.image = personsForRound[2].image
                imageView3.image = personsForRound.first?.image
                imageView4.image = personsForRound[3].image
            case 4:
                imageView1.image = personsForRound[1].image
                imageView2.image = personsForRound[2].image
                imageView3.image = personsForRound[3].image
                imageView4.image = personsForRound.first?.image
            default:
                fatalError("Invalid correctAnswer randomized")
            }

        } else {

            singleNameView.isHidden = true
            singleImageView.isHidden = false
            imageView.image = personsForRound.first?.image

            switch correctAnswer {
            case 1:
                nameButton1.setTitle(personsForRound.first?.name, for: .normal)
                nameButton2.setTitle(personsForRound[1].name, for: .normal)
                nameButton3.setTitle(personsForRound[2].name, for: .normal)
                nameButton4.setTitle(personsForRound[3].name, for: .normal)
            case 2:
                nameButton1.setTitle(personsForRound[1].name, for: .normal)
                nameButton2.setTitle(personsForRound.first?.name, for: .normal)
                nameButton3.setTitle(personsForRound[2].name, for: .normal)
                nameButton4.setTitle(personsForRound[3].name, for: .normal)
            case 3:
                nameButton1.setTitle(personsForRound[1].name, for: .normal)
                nameButton2.setTitle(personsForRound[2].name, for: .normal)
                nameButton3.setTitle(personsForRound.first?.name, for: .normal)
                nameButton4.setTitle(personsForRound[3].name, for: .normal)
            case 4:
                nameButton1.setTitle(personsForRound[1].name, for: .normal)
                nameButton2.setTitle(personsForRound[2].name, for: .normal)
                nameButton3.setTitle(personsForRound[3].name, for: .normal)
                nameButton4.setTitle(personsForRound.first?.name, for: .normal)
            default:
                fatalError("Invalid correctAnswer randomized")
            }
        }
    }
    
    //========================================
    // MARK: - Navigation
    //========================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ResultsViewController else {fatalError("quiz did not segue to results")}
        
        destination.loadViewIfNeeded()
        destination.percentageLabel.text = String(Int(100 * (amountCorrect / Float(maxRounds)))) + " %"
    }
    
    @IBAction func unwindToQuizViewController(sender: UIStoryboardSegue) {
        
        if let game = game {
            gender = game.originalGender
        }

        switch sender.identifier {
        case "unwindFromReplayButton":
            //newGame() will create the correct game settings again, as long as gender is set from originalGender beforehand
            game = nil
        case "unwindFromRetrySetButton":
            if let game = game {
                switch game.originalGender {
                case .male:
                    game.remainingPossibleMales = game.malesUsed
                case .female:
                    game.remainingPossibleFemales = game.femalesUsed
                case .random:
                    game.remainingPossibleMales = game.malesUsed
                    game.remainingPossibleFemales = game.femalesUsed
                }

                game.malesUsed.removeAll()
                game.femalesUsed.removeAll()
            }
        default:
            fatalError("unwinded to QuizViewController from unkown source")
        }
        
        newGame()
    }
}
