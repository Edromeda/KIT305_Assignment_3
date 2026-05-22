//
//  RoomListViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class RoomListViewController: UITableViewController {
    
    var house: House
    var rooms: [Room] = []
    let db = Firestore.firestore()
    
    // MARK: - Init
    init(house: House) {
        self.house = house
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = house.customerName
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RoomCell")
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoomTapped)),
            UIBarButtonItem(title: "Edit House", style: .plain, target: self, action: #selector(editHouseTapped))
        ]
        
        fetchRooms()
    }
    
    // MARK: - Firestore
    func fetchRooms() {
        db.collection("houses").document(house.id).collection("rooms")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching rooms: \(error)")
                    return
                }
                self.rooms = snapshot?.documents.compactMap {
                    Room(id: $0.documentID, data: $0.data())
                } ?? []
                self.tableView.reloadData()
            }
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.name
        cell.detailTextLabel?.text = "Labour: $\(String(format: "%.2f", room.labourCost))"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = rooms[indexPath.row]
            db.collection("houses").document(house.id).collection("rooms").document(room.id).delete()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        let vc = RoomDetailViewController(house: house, room: room)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Actions
    @objc func addRoomTapped() {
        let vc = AddEditRoomViewController(house: house, room: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editHouseTapped() {
        let vc = AddEditHouseViewController(house: house)
        navigationController?.pushViewController(vc, animated: true)
    }
}
