//
//  PersonLists.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

var femaleList: [Person] = []
var maleList: [Person] = []

func savePersonList(gender: Gender) {
    
    if gender == .male {
        let worked = NSKeyedArchiver.archiveRootObject(maleList, toFile: Person.MaleArchiveURL.path)
        print(worked)
    } else {
        NSKeyedArchiver.archiveRootObject(femaleList, toFile: Person.FemaleArchiveURL.path)
    }
}

func loadPersonLists() {
    
    if let unwrappedList = NSKeyedUnarchiver.unarchiveObject(withFile: Person.MaleArchiveURL.path) as? [Person] {
        maleList = unwrappedList
    }
    if let unwrappedList = NSKeyedUnarchiver.unarchiveObject(withFile: Person.FemaleArchiveURL.path) as? [Person] {
        femaleList = unwrappedList
    }
}
