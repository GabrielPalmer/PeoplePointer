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
    
    @IBOutlet var imageTapGesture1: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture2: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture3: UITapGestureRecognizer!
    @IBOutlet var imageTapGesture4: UITapGestureRecognizer!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var roundProgressBar: UIProgressView!
    
    var roundFinished: Bool = false
    var correctImageView: Int?
    var correctPerson: Person?
    var round: Int = 1
    var maxRounds: Int = 4 //default minimum rounds
    var gender: Gender = .random //default gender
    var game: Game?
    
    //change to viewWillLoad?
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
        
        nextButton.isHidden = true
        game = Game(forList: gender)
        newRound()
        
    }

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        if !roundFinished {
            imageView1.layer.borderColor = correctImageView == imageView1.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView2.layer.borderColor = correctImageView == imageView2.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView3.layer.borderColor = correctImageView == imageView3.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            imageView4.layer.borderColor = correctImageView == imageView4.tag ? UIColor.green.cgColor : UIColor.red.cgColor
            
            imageView1.backgroundColor = correctImageView == imageView1.tag ? UIColor.green : UIColor.red
            imageView2.backgroundColor = correctImageView == imageView2.tag ? UIColor.green : UIColor.red
            imageView3.backgroundColor = correctImageView == imageView3.tag ? UIColor.green : UIColor.red
            imageView4.backgroundColor = correctImageView == imageView4.tag ? UIColor.green : UIColor.red
        }
        
        roundFinished = true
        nextButton.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if round == maxRounds {
            //segue here then return
            fatalError("End of implementation")
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
    
        imageView1.layer.borderColor = UIColor.clear.cgColor
        imageView2.layer.borderColor = UIColor.clear.cgColor
        imageView3.layer.borderColor = UIColor.clear.cgColor
        imageView4.layer.borderColor = UIColor.clear.cgColor
        imageView1.backgroundColor = UIColor.clear
        imageView2.backgroundColor = UIColor.clear
        imageView3.backgroundColor = UIColor.clear
        imageView4.backgroundColor = UIColor.clear
        
        if let game = game {
            var personsForRound: [Person] = []
            var randomGender: Gender = .random //when gender = .random, must be set to male/female or app will crash
            
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
            
            //selects random image view for correct answer and sets name label
            correctImageView = Int(arc4random_uniform(4)) + 1
            nameLabel.text = personsForRound.first?.name
            
            switch correctImageView {
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
            
            
        }
        
    }
    
}

