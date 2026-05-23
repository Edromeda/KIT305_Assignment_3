//
//  AddEditViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import UIKit
import FirebaseFirestore

class AddEditHouseViewController: UIViewController {
    
    var house: House?
    let db = Firestore.firestore()
    
    // MARK: - UI Elements
    let customerNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Customer Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let addressField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Address"
        tf.borderStyle = .roundedRect
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
    init(house: House?) {
        self.house = house
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = house == nil ? "Add House" : "Edit House"
        setupLayout()
        
        // If editing, pre-fill the fields
        if let house = house {
            customerNameField.text = house.customerName
            addressField.text = house.address
        }
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    // MARK: - Layout
    func setupLayout() {
        view.addSubview(customerNameField)
        view.addSubview(addressField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            customerNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            customerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customerNameField.heightAnchor.constraint(equalToConstant: 44),
            
            addressField.topAnchor.constraint(equalTo: customerNameField.bottomAnchor, constant: 16),
            addressField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addressField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func saveTapped() {
        guard let customerName = customerNameField.text, !customerName.isEmpty,
              let address = addressField.text, !address.isEmpty else {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let data: [String: Any] = ["customerName": customerName, "address": address]
        if let house = house {
            db.collection("houses").document(house.id).updateData(data)
        } else {
            db.collection("houses").addDocument(data: data)
        }
        navigationController?.popViewController(animated: true)
    }
}
