//
//  PersonListsTableViewController.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class PersonListsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var gender: Gender = .male

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Males"
    }

    //========================================
    // MARK: - Table view data source
    //========================================

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gender == .male ? maleList.count : femaleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        let person = gender == .male ? maleList[indexPath.row] : femaleList[indexPath.row]

        cell.picture.image = person.image
        cell.nameLabel.text = person.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editPerson", sender: nil)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if gender == .male {
                maleList.remove(at: indexPath.row)
            } else {
                femaleList.remove(at: indexPath.row)
            }

            savePersonList(gender: gender)

            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //===========================================
    // MARK: - Actions
    //===========================================

    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        gender = sender.selectedSegmentIndex == 0 ? Gender.male : Gender.female
        navigationItem.title = gender == .male ? "Males" : "Females"
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addPerson", sender: nil)
    }
    
    //========================================
    // MARK: - Navigation
    //========================================

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "editPerson":
            
            guard
                let destination = segue.destination as? EditPersonViewController,
                let sender = sender as? PersonTableViewCell,
                let indexpath = tableView.indexPath(for: sender)
                else { fatalError("invalid segue to editPersonViewController") }

            destination.loadViewIfNeeded()
            destination.navigationItem.title = "Edit Person"

            destination.person = gender == .male ? maleList[indexpath.row] : femaleList[indexpath.row]
            destination.saveButton.isEnabled = true
            destination.scrollView.isScrollEnabled = true
            destination.imageSelected = true
            destination.scrollView.layoutIfNeeded()
            destination.updateZoomFor(size: CGSize(width: 200, height: 200))
            
        case "addPerson":
            
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? EditPersonViewController else {fatalError()}
            
            destination.loadViewIfNeeded()
            destination.navigationItem.title = "Add \(gender == .male ? "Male" : "Female")"
            destination.saveButton.isEnabled = false
            destination.scrollView.isScrollEnabled = false

        case "unwindToMainViewController":
            break
        default:
            fatalError("unknown segue identifier")
        }
    }
    
    @IBAction func unwindToPersonListTableViewController(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? EditPersonViewController,
            let person = sourceViewController.person {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //update person
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                //add person
                if gender == .male {
                    maleList.insert(person, at: 0)
                } else {
                    femaleList.insert(person, at: 0)
                }
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }

            savePersonList(gender: gender)
        }
    }
}

