//
//  AddEditItemViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//


import UIKit

class AddEditItemViewController: UIViewController {
    var house: House
    var room: Room
    var window: WindowItem?
    var floorSpace: FloorSpace?
    var isWindow: Bool
    
    init(house: House, room: Room, window: WindowItem?, floorSpace: FloorSpace?, isWindow: Bool = true) {
        self.house = house
        self.room = room
        self.window = window
        self.floorSpace = floorSpace
        self.isWindow = window != nil ? true : isWindow
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = isWindow ? "Window" : "Floor Space"
    }
}