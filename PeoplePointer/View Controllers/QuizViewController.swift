//
//  QuizViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    enum QuestionType {
        case singleImage, singleName
    }
    
    @IBOutlet weak var singleImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameButton1: UIButton!
    @IBOutlet weak var nameButton2: UIButton!
    @IBOutlet weak var nameButton3: UIButton!
    @IBOutlet weak var nameButton4: UIButton!
    
    
    
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
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var roundProgressBar: UIProgressView!
    
    //placeholder values are just meant to be non-optional and variables will have their true values set later
    var roundFinished: Bool = false
    var questionType: QuestionType = .singleImage   //placeholder
    var correctAnswer: Int?
    var round: Int = 1
    var maxRounds: Int = 4//placeholder
    var amountCorrect: Float = 0
    var gender: Gender = .random   //placeholder
    var game: Game?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundFinished = false
        round = 1
        amountCorrect = 0
        
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
        
        nextButton.isHidden = true
        game = Game(forList: gender)
        newRound()
    }
    
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
        nextButton.isHidden = false
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
        nextButton.isHidden = false
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
    
    
    //add recursive functionality to personsForRound?
    func newRound() {
        roundFinished = false
        nextButton.isHidden = true
        
        roundProgressBar.setProgress(Float(round) / Float(maxRounds), animated: true)
    
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
        
        
        if let game = game {
            var correctPerson: Person?
            var personsForRound: [Person] = []
            var randomGender: Gender = .random   //when gender = .random, must be set to male/female or app will crash
            
            //gets answer person for round which is always first index of personsForRound
            switch gender {
                
            case .male:
                correctPerson = game.remainingPossibleMales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleMales.count))))
                
            case .female:
                correctPerson = game.remainingPossibleFemales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleFemales.count))))
                
            case .random:
                
                //check if all names of a list have been used, if so set gender from random to only use remaining list
                if game.remainingPossibleMales.count == 0 {
                    gender = .female
                    correctPerson = game.remainingPossibleFemales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleFemales.count))))
                    break
                } else if game.remainingPossibleFemales.count == 0 {
                    gender = .male
                    correctPerson = game.remainingPossibleMales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleMales.count))))
                    break
                }
                
                //gets random person from remaining gender list and ensure the other fill persons will be that gender
                if arc4random_uniform(2) == 0 {
                    randomGender = .male
                    correctPerson = game.remainingPossibleMales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleMales.count))))
                } else {
                    randomGender = .female
                    correctPerson = game.remainingPossibleFemales.remove(at: Int(arc4random_uniform(UInt32(game.remainingPossibleFemales.count))))
                }
            }
            personsForRound.append(correctPerson!)
            
            //fills 3 more persons in personsForRound ensuring no duplicates
            for _ in 0...2 {
                var person: Person?
                
                switch gender {
                    
                case .male:
                    repeat {
                        person = game.allPossibleMales[Int(arc4random_uniform(UInt32(game.allPossibleMales.count)))]
                    } while personsForRound.contains(person!)
                    
                case .female:
                    repeat {
                        person = game.allPossibleFemales[Int(arc4random_uniform(UInt32(game.allPossibleFemales.count)))]
                    } while personsForRound.contains(person!)
                    
                case .random:
                    if randomGender == .male {
                        repeat {
                            person = game.allPossibleMales[Int(arc4random_uniform(UInt32(game.allPossibleMales.count)))]
                        } while personsForRound.contains(person!)
                    } else if randomGender == .female {
                        repeat {
                            person = game.allPossibleFemales[Int(arc4random_uniform(UInt32(game.allPossibleFemales.count)))]
                        } while personsForRound.contains(person!)
                    }
                }
                
                personsForRound.append(person!)
            }
            
            //selects random question type and imageView/label for correct answer
            questionType = Int(arc4random_uniform(2)) == 0 ? .singleImage : .singleName
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
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ResultsViewController else {fatalError("quiz did not segue to results")}
        
        destination.game = game
        destination.loadViewIfNeeded()
        destination.percentageLabel.text = String(Int(100 * (amountCorrect / Float(maxRounds)))) + "%"
    }
    
    @IBAction func unwindToQuizViewController(sender: UIStoryboardSegue) {
        //use the fact that unwind doesn't reload the view controller to your advantage
    }
    
}

