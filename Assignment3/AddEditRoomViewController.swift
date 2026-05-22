//
//  AddEditRoomViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//


import UIKit

class AddEditRoomViewController: UIViewController {
    var house: House
    var room: Room?
    
    init(house: House, room: Room?) {
        self.house = house
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = room == nil ? "Add Room" : "Edit Room"
    }
}