//
//  QuoteViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 23/5/2026.
//


import UIKit
import FirebaseFirestore

class QuoteViewController: UITableViewController {
    
    var house: House
    var rooms: [Room] = []
    var windowsByRoom: [String: [WindowItem]] = [:]
    var floorSpacesByRoom: [String: [FloorSpace]] = [:]
    let db = Firestore.firestore()
    
    let windowRate = 50.0
    let floorRate = 100.0
    
    init(house: House) {
        self.house = house
        super.init(style: .grouped)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quote"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        fetchRooms()
    }
    
    func fetchRooms() {
        db.collection("houses").document(house.id).collection("rooms").getDocuments { snapshot, error in
            if let error = error { print("Error: \(error)"); return }
            self.rooms = snapshot?.documents.compactMap {
                Room(id: $0.documentID, data: $0.data())
            } ?? []
            self.fetchAllItems()
        }
    }
    
    func fetchAllItems() {
        let group = DispatchGroup()
        
        for room in rooms {
            let roomRef = db.collection("houses").document(house.id).collection("rooms").document(room.id)
            
            group.enter()
            roomRef.collection("windows").getDocuments { snapshot, _ in
                self.windowsByRoom[room.id] = snapshot?.documents.compactMap {
                    WindowItem(id: $0.documentID, data: $0.data())
                } ?? []
                group.leave()
            }
            
            group.enter()
            roomRef.collection("floorSpaces").getDocuments { snapshot, _ in
                self.floorSpacesByRoom[room.id] = snapshot?.documents.compactMap {
                    FloorSpace(id: $0.documentID, data: $0.data())
                } ?? []
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func roomTotal(for room: Room) -> Double {
        let windowCost = (windowsByRoom[room.id] ?? []).reduce(0.0) { $0 + $1.areaSqm * $1.effectiveRate }
        let floorCost = (floorSpacesByRoom[room.id] ?? []).reduce(0.0) { $0 + $1.areaSqm * $1.effectiveRate }
        return windowCost + floorCost + room.labourCost
    }
    
    func houseTotal() -> Double {
        return rooms.reduce(0.0) { $0 + roomTotal(for: $1) }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rooms.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < rooms.count {
            return rooms[section].name
        }
        return "Total"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < rooms.count {
            let room = rooms[section]
            let windowCount = windowsByRoom[room.id]?.count ?? 0
            let floorCount = floorSpacesByRoom[room.id]?.count ?? 0
            return windowCount + floorCount + 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "QuoteCell")
        }
        
        if indexPath.section < rooms.count {
            let room = rooms[indexPath.section]
            let windows = windowsByRoom[room.id] ?? []
            let floors = floorSpacesByRoom[room.id] ?? []
            
            if indexPath.row < windows.count {
                let w = windows[indexPath.row]
                let productLabel = w.productName != nil ? " (\(w.productName!))" : ""
                cell?.textLabel?.text = "Window: \(w.name)\(productLabel)"
                cell?.detailTextLabel?.text = String(format: "$%.2f", w.areaSqm * w.effectiveRate)
            } else if indexPath.row < windows.count + floors.count {
                let f = floors[indexPath.row - windows.count]
                let productLabel = f.productName != nil ? " (\(f.productName!))" : ""
                cell?.textLabel?.text = "Floor: \(f.name)\(productLabel)"
                cell?.detailTextLabel?.text = String(format: "$%.2f", f.areaSqm * f.effectiveRate)
            } else {
                cell?.textLabel?.text = "Labour"
                cell?.detailTextLabel?.text = String(format: "$%.2f", room.labourCost)
            }
        } else {
            cell?.textLabel?.text = "House Total"
            cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            cell?.detailTextLabel?.text = String(format: "$%.2f", houseTotal())
            cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        return cell!
    }
    
    @objc func shareTapped() {
        var text = "Quote for \(house.customerName)\n\(house.address)\n\n"
        
        for room in rooms {
            text += "Room: \(room.name)\n"
            for w in windowsByRoom[room.id] ?? [] {
                text += "  Window - \(w.name): \(String(format: "$%.2f", w.areaSqm * w.effectiveRate))\n"
            }
            for f in floorSpacesByRoom[room.id] ?? [] {
                text += "  Floor - \(f.name): \(String(format: "$%.2f", f.areaSqm * f.effectiveRate))\n"
            }
            text += "  Labour: \(String(format: "$%.2f", room.labourCost))\n"
            text += "  Room Total: \(String(format: "$%.2f", roomTotal(for: room)))\n\n"
        }
        
        text += "TOTAL: \(String(format: "$%.2f", houseTotal()))"
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true)
    }
}
