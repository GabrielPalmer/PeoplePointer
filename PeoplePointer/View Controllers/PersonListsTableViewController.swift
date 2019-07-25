//
//  PersonListsTableViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class PersonListsTableViewController: UITableViewController {

    var gender: Gender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //========================================
    // MARK: - Table view data source
    //========================================

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gender == .male ? maleList.count : femaleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell

        cell.picture.image = (gender == .male ? maleList[indexPath.row].image : femaleList[indexPath.row].image)
        cell.nameLabel.text = (gender == .male ? maleList[indexPath.row].name : femaleList[indexPath.row].name)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if gender == .male {
                maleList.remove(at: indexPath.row)
            } else {
                femaleList.remove(at: indexPath.row)
            }
            
            if let gender = gender {
                savePersonList(gender: gender)
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //========================================
    // MARK: - Navigation
    //========================================

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "editPerson":
            
            guard let destination = segue.destination as? EditPersonViewController else { fatalError("unkown segue destination") }
            
            guard let sender = sender as? PersonTableViewCell else { fatalError("sender was not PersonTableViewCell") }
            guard let indexpath = tableView.indexPath(for: sender) else { fatalError("cell was not in table") }
            
            let selectedPerson = (gender == .male) ? maleList[indexpath.row] : femaleList[indexpath.row]
            
            destination.loadViewIfNeeded()
            
            destination.imageView.image = selectedPerson.image
            destination.nameTextField.text = selectedPerson.name
            destination.navigationItem.title = "Edit Person"
            destination.saveButton.isEnabled = true
            
            destination.scrollView.isScrollEnabled = true
            destination.imageSelected = true
            
            destination.scrollView.layoutIfNeeded()
            destination.updateZoomFor(size: CGSize(width: 200, height: 200))
            
        case "addPerson":
            
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? EditPersonViewController else {fatalError()}
            
            destination.loadViewIfNeeded()
            
            destination.navigationItem.title = "Add Person"
            destination.saveButton.isEnabled = false
            destination.scrollView.isScrollEnabled = false
            
        case "unwindToMainViewController":
            break
        default:
            fatalError("Unexpected segue destination")
        }
    }
    
    @IBAction func unwindToPersonListTableViewController(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? EditPersonViewController, let person = sourceViewController.person {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                //update person
                if gender == .male {
                    maleList[selectedIndexPath.row] = person
                } else {
                    femaleList[selectedIndexPath.row] = person
                }
                
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                
            } else {
                
                //add person
                let newIndexPath = IndexPath(row: 0, section: 0)
                
                if gender == .male {
                    maleList.insert(person, at: 0)
                } else {
                    femaleList.insert(person, at: 0)
                }
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //save the updated list
            if let gender = gender {
                savePersonList(gender: gender)
            }
            
        }
    }
    
}

