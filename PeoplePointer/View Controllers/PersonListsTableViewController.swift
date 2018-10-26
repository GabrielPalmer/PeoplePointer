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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gender == .male ? maleList.count : femaleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell

        cell.picture.image = (gender == .male ? maleList[indexPath.row].image : femaleList[indexPath.row].image)
        cell.nameLabel.text = (gender == .male ? maleList[indexPath.row].name : femaleList[indexPath.row].name)

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
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
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "editPerson" {
            
            guard let destination = segue.destination as? EditPersonViewController else {return}
            
            guard let sender = sender as? PersonTableViewCell else {return}
            guard let indexpath = tableView.indexPath(for: sender) else {return}
            
            let selectedPerson = (gender == .male) ? maleList[indexpath.row] : femaleList[indexpath.row]
            
            destination.loadViewIfNeeded()
            
            destination.imageView.image = selectedPerson.image
            destination.nameTextField.text = selectedPerson.name
            destination.navigationItem.title = "Edit Person"
            destination.saveButton.isEnabled = true
            
        } else {
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? EditPersonViewController else {fatalError()}
            destination.navigationItem.title = "Add Person"
            destination.saveButton.isEnabled = false
            
        }
    }
    
    //MARK: Actions
    
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

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

