//
//  RoomListViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class RoomListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var house: House
    var rooms: [Room] = []
    let db = Firestore.firestore()
    
    let tableView = UITableView()
    
    let quoteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View Quote", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    init(house: House) {
        self.house = house
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = house.customerName
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoomTapped)),
            UIBarButtonItem(title: "Edit House", style: .plain, target: self, action: #selector(editHouseTapped))
        ]
        
        setupTableView()
        setupQuoteButton()
        fetchRooms()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RoomCell")
        view.addSubview(tableView)
        view.addSubview(quoteButton)
        
        quoteButton.addTarget(self, action: #selector(quoteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: quoteButton.topAnchor),
            
            quoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            quoteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quoteButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func setupQuoteButton() {}
    
    func fetchRooms() {
        db.collection("houses").document(house.id).collection("rooms")
            .addSnapshotListener { snapshot, error in
                if let error = error { print("Error: \(error)"); return }
                self.rooms = snapshot?.documents.compactMap {
                    Room(id: $0.documentID, data: $0.data())
                } ?? []
                self.tableView.reloadData()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "RoomCell")
        }
        let room = rooms[indexPath.row]
        cell?.textLabel?.text = room.name
        cell?.detailTextLabel?.text = "Labour: $\(String(format: "%.2f", room.labourCost))"
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = rooms[indexPath.row]
            db.collection("houses").document(house.id).collection("rooms").document(room.id).delete()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        let vc = RoomDetailViewController(house: house, room: room)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addRoomTapped() {
        let vc = AddEditRoomViewController(house: house, room: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editHouseTapped() {
        let vc = AddEditHouseViewController(house: house)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func quoteTapped() {
        let vc = QuoteViewController(house: house)
        navigationController?.pushViewController(vc, animated: true)
    }
}
