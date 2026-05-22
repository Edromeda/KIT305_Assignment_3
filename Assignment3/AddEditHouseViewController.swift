//
//  AddEditViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit

class AddEditHouseViewController: UIViewController {
    var house: House?
    
    init(house: House?) {
        self.house = house
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = house == nil ? "Add House" : "Edit House"
    }
}
