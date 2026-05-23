//
//  AddEditItemViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//


import UIKit
import FirebaseFirestore

class AddEditItemViewController: UIViewController {
    
    var house: House
    var room: Room
    var window: WindowItem?
    var floorSpace: FloorSpace?
    var isWindow: Bool
    let db = Firestore.firestore()
    
    let nameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name (e.g. Front Window)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let widthField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Width (mm)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let heightField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Height (mm)"
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
    
    init(house: House, room: Room, window: WindowItem?, floorSpace: FloorSpace?, isWindow: Bool = true) {
        self.house = house
        self.room = room
        self.window = window
        self.floorSpace = floorSpace
        self.isWindow = window != nil ? true : (floorSpace != nil ? false : isWindow)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = isWindow ? (window == nil ? "Add Window" : "Edit Window") : (floorSpace == nil ? "Add Floor Space" : "Edit Floor Space")
        setupLayout()
        
        if let w = window {
            nameField.text = w.name
            widthField.text = String(w.widthMm)
            heightField.text = String(w.heightMm)
        } else if let f = floorSpace {
            nameField.text = f.name
            widthField.text = String(f.widthMm)
            heightField.text = String(f.heightMm)
        }
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.addSubview(nameField)
        view.addSubview(widthField)
        view.addSubview(heightField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 44),
            
            widthField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            widthField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            widthField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            widthField.heightAnchor.constraint(equalToConstant: 44),
            
            heightField.topAnchor.constraint(equalTo: widthField.bottomAnchor, constant: 16),
            heightField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heightField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            heightField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: heightField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func saveTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let widthText = widthField.text, let width = Double(widthText),
              let heightText = heightField.text, let height = Double(heightText) else {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in all fields correctly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let data: [String: Any] = ["name": name, "widthMm": width, "heightMm": height]
        let roomRef = db.collection("houses").document(house.id).collection("rooms").document(room.id)
        
        if isWindow {
            if let w = window {
                roomRef.collection("windows").document(w.id).updateData(data) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                roomRef.collection("windows").addDocument(data: data) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if let f = floorSpace {
                roomRef.collection("floorSpaces").document(f.id).updateData(data) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                roomRef.collection("floorSpaces").addDocument(data: data) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
