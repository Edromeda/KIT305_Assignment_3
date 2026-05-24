//
//  ProductPickerViewController.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 24/5/2026.
//
import UIKit

class ProductPickerViewController: UITableViewController {
    
    var category: String
    var products: [Product] = []
    var onProductSelected: ((Product, String) -> Void)?
    
    init(category: String) {
        self.category = category
        super.init(style: .plain)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Product"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        fetchProducts()
    }
    
    func fetchProducts() {
        guard let url = URL(string: "https://utasbot.dev/kit305_2026/product") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    let all = dataArray.compactMap { Product(dict: $0) }
                    self.products = all.filter { $0.category == self.category }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            } catch { print("JSON error: \(error)") }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ProductCell")
        }
        let product = products[indexPath.row]
        cell?.textLabel?.text = product.name
        cell?.detailTextLabel?.text = "$\(Int(product.pricePerSqm))/m²"
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        let alert = UIAlertController(title: "Select Variant", message: product.name, preferredStyle: .actionSheet)
        for variant in product.variants {
            alert.addAction(UIAlertAction(title: variant, style: .default) { _ in
                self.onProductSelected?(product, variant)
                self.navigationController?.popViewController(animated: true)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
