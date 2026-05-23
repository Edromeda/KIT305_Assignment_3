//
//  AddEditRoomViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class AddEditRoomViewController: UIViewController {
    
    var house: House
    var room: Room?
    let db = Firestore.firestore()
    
    // MARK: - UI Elements
    let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Room Name (e.g. Living Room)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let labourCostField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Labour Cost ($)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    init(house: House, room: Room?) {
        self.house = house
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = room == nil ? "Add Room" : "Edit Room"
        setupLayout()
        
        if let room = room {
            nameField.text = room.name
            labourCostField.text = String(room.labourCost)
        }
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    // MARK: - Layout
    func setupLayout() {
        view.addSubview(nameField)
        view.addSubview(labourCostField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 44),
            
            labourCostField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            labourCostField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labourCostField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labourCostField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: labourCostField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func saveTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let labourText = labourCostField.text,
              let labourCost = Double(labourText) else {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in all fields correctly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let data: [String: Any] = ["name": name, "labourCost": labourCost]
        let roomsRef = db.collection("houses").document(house.id).collection("rooms")
        if let room = room {
            roomsRef.document(room.id).updateData(data)
        } else {
            roomsRef.addDocument(data: data)
        }
        navigationController?.popViewController(animated: true)
    }
}
