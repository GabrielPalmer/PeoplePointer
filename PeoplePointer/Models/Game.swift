//
//  Game.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/29/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

class Game {
    var remainingPossibleMales: [Person]
    var remainingPossibleFemales: [Person]
    let allPossibleMales: [Person]
    let allPossibleFemales: [Person]
    
    init(forList gender: Gender) {
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
}
