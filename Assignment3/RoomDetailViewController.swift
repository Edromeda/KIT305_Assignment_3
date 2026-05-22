//
//  RoomDetailViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class RoomDetailViewController: UITableViewController {
    
    var house: House
    var room: Room
    var windows: [WindowItem] = []
    var floorSpaces: [FloorSpace] = []
    let db = Firestore.firestore()
    
    init(house: House, room: Room) {
        self.house = house
        self.room = room
        super.init(style: .grouped)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = room.name
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemTapped)),
            UIBarButtonItem(title: "Edit Room", style: .plain, target: self, action: #selector(editRoomTapped))
        ]
        fetchWindows()
        fetchFloorSpaces()
    }
    
    func roomRef() -> DocumentReference {
        return db.collection("houses").document(house.id).collection("rooms").document(room.id)
    }
    
    func fetchWindows() {
        roomRef().collection("windows").addSnapshotListener { snapshot, error in
            if let error = error { print("Error: \(error)"); return }
            self.windows = snapshot?.documents.compactMap {
                WindowItem(id: $0.documentID, data: $0.data())
            } ?? []
            self.tableView.reloadData()
        }
    }
    
    func fetchFloorSpaces() {
        roomRef().collection("floorSpaces").addSnapshotListener { snapshot, error in
            if let error = error { print("Error: \(error)"); return }
            self.floorSpaces = snapshot?.documents.compactMap {
                FloorSpace(id: $0.documentID, data: $0.data())
            } ?? []
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Windows" : "Floor Spaces"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? windows.count : floorSpaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
        }
        if indexPath.section == 0 {
            let w = windows[indexPath.row]
            cell?.textLabel?.text = w.name
            cell?.detailTextLabel?.text = "\(Int(w.widthMm))mm × \(Int(w.heightMm))mm"
        } else {
            let f = floorSpaces[indexPath.row]
            cell?.textLabel?.text = f.name
            cell?.detailTextLabel?.text = "\(Int(f.widthMm))mm × \(Int(f.heightMm))mm"
        }
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                roomRef().collection("windows").document(windows[indexPath.row].id).delete()
            } else {
                roomRef().collection("floorSpaces").document(floorSpaces[indexPath.row].id).delete()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = AddEditItemViewController(house: house, room: room, window: windows[indexPath.row], floorSpace: nil)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = AddEditItemViewController(house: house, room: room, window: nil, floorSpace: floorSpaces[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addItemTapped() {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Window", style: .default) { _ in
            let vc = AddEditItemViewController(house: self.house, room: self.room, window: nil, floorSpace: nil, isWindow: true)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Floor Space", style: .default) { _ in
            let vc = AddEditItemViewController(house: self.house, room: self.room, window: nil, floorSpace: nil, isWindow: false)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func editRoomTapped() {
        let vc = AddEditRoomViewController(house: house, room: room)
        navigationController?.pushViewController(vc, animated: true)
    }
}
