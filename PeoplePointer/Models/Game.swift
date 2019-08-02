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
            fatalError(".random gender was passed to removePersonFromList()")
        }
        
        if gender == .male {
            return remainingPossibleMales.remove(at: Int.random(in: 0..<remainingPossibleMales.count))
        } else {
            return remainingPossibleFemales.remove(at: Int.random(in: 0..<remainingPossibleFemales.count))
        }
    }
    
    //fuction for filling in wrong answers
    func getPersonFromList(gender: Gender) -> Person {
        if gender == .random {
            fatalError(".random gender was passed to getPersonFromList()")
        }
        
        if gender == .male {
            return allPossibleMales[Int.random(in: 0..<allPossibleMales.count)]
        } else {
            return allPossibleFemales[Int.random(in: 0..<allPossibleFemales.count)]
        }
    }
}
