//
//  CabinetsViewController.swift
//  DigitalCabinet
//
//  Created by admin on 17.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import SwipeCellKit
import FirebaseAuth

class CabinetsViewController: SwipeTableViewController {

    let db = Firestore.firestore()
    var cabinetID: String = ""
    var cabinets: [Cabinet] = []
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCabinets()
        
        navigationItem.setHidesBackButton(true, animated: true)
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation")}
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0) as Any]
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cabinets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cabinet = cabinets[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0)
        cell.textLabel?.text = cabinet.name
       
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods

    func loadCabinets() {
        
        db.collection(K.CabinetFStore.cabinetCollectionName).whereField("Owner", isEqualTo: Auth.auth().currentUser?.email! as Any).addSnapshotListener { querySnapshot, error in
            self.cabinets = []
            if let e = error {
                print("there was an issue retrieving data from the database\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let id = data[K.CabinetFStore.id] as? String, let owner = data[K.CabinetFStore.owner] as? String, let name = data[K.CabinetFStore.name] as? String {
                            let newCabinet = Cabinet( id: id, owner: owner, name: name)
                            self.cabinets.append(newCabinet)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.cabinets.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: - Add New Cabinets
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: K.AddButton.cabinetAlertTitle, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.AddButton.cabinetActionTitle, style: .default) {
            (action) in
            let id = UUID().uuidString
            self.cabinetID = id
            if let cabinetName = textField.text, let owner = Auth.auth().currentUser?.email {
                self.db.collection(K.CabinetFStore.cabinetCollectionName).document(id).setData([
                    "ID": id,
                    "Name": cabinetName,
                    "Owner": owner
                ]) {
                    (error) in
                    if let e = error {
                        print("there was a mistake\(e)")
                    } else {
                        print("data saved")
                    }
                }
            }
        }

        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = K.AddButton.cabinetTextFieldPlaceHolder
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
       
    }
    
    
    //MARK: - Delete Cabinets
    
    override func updateModels(at indexPath: IndexPath) {
        
        self.cabinets.remove(at: indexPath.row)
        db.collection(K.CabinetFStore.cabinetCollectionName).document(self.cabinetID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cabinetID = cabinets[indexPath.row].id
        print("inside didSelect id = \(self.cabinetID)")
        performSegue(withIdentifier: K.Segues.groceriesSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GroceriesViewController
        
        if tableView.indexPathForSelectedRow != nil {
            destinationVC.selectedCabinet = self.cabinetID
            print("cabinet id = \(cabinetID)")
        }
    }
    
}


    //MARK: - SearchBar Methods

extension CabinetsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        cabinets = cabinets.filter { $0.name.contains(searchBar.text ?? "") }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadCabinets()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
