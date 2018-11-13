//
//  Game.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/29/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation
import UIKit

class Game {
    var remainingPossibleMales: [Person]
    var remainingPossibleFemales: [Person]
    let allPossibleMales: [Person]
    let allPossibleFemales: [Person]
    
    var malesUsed: [Person] = []
    var femalesUsed: [Person] = []
    
    //used for when user replays a game but gender in quizViewController changed because a list ran out
    var originalGender: Gender
    
    init(forList gender: Gender) {
        originalGender = gender
        
        switch gender {
            
        case .male:
            remainingPossibleMales = maleList
            allPossibleMales = maleList
            remainingPossibleFemales = []
            allPossibleFemales = []
            
        case .female:
            remainingPossibleFemales = femaleList
            allPossibleFemales = femaleList
            remainingPossibleMales = []
            allPossibleMales = []
            
        case .random:
            remainingPossibleMales = maleList
            allPossibleMales = maleList
            remainingPossibleFemales = femaleList
            allPossibleFemales = femaleList
        }
    }
    
    //function for getting the correct person
    func removePersonFromList(gender: Gender) -> Person {
        if gender == .random {
            print("warning: .random gender was passed to removePersonFromList()")
            return Person(image: UIImage(named: "randomPlaceholder")!, name: "Default Person")
        }
        
        if gender == .male {
            return remainingPossibleMales.remove(at: Int(arc4random_uniform(UInt32(remainingPossibleMales.count))))
        } else {
            return remainingPossibleFemales.remove(at: Int(arc4random_uniform(UInt32(remainingPossibleFemales.count))))
        }
    }
    
    //fuction for filling in wrong answers
    func getPersonFromList(gender: Gender) -> Person {
        if gender == .random {
            print("warning: .random gender was passed to getPersonFromList()")
            return Person(image: UIImage(named: "randomPlaceholder")!, name: "Default Person")
        }
        
        if gender == .male {
            return allPossibleMales[Int(arc4random_uniform(UInt32(allPossibleMales.count)))]
        } else {
            return allPossibleFemales[Int(arc4random_uniform(UInt32(allPossibleFemales.count)))]
        }
    }
}
