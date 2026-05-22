//
//  HouseListViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class HouseListViewController: UITableViewController {
    
    var houses: [House] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Houses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addHouseTapped)
        )
        fetchHouses()
    }
    
    // MARK: - Firestore
    func fetchHouses() {
        db.collection("houses").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            self.houses = snapshot?.documents.compactMap {
                House(id: $0.documentID, data: $0.data())
            } ?? []
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath)
        let house = houses[indexPath.row]
        cell.textLabel?.text = house.customerName
        cell.detailTextLabel?.text = house.address
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let house = houses[indexPath.row]
            db.collection("houses").document(house.id).delete()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let house = houses[indexPath.row]
        let vc = RoomListViewController(house: house)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    @objc func addHouseTapped() {
        let vc = AddEditHouseViewController(house: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
