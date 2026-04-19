//
//  ProductManagmentCell.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit

final class ProductManagementCell: UITableViewCell {
    
    var onStockChange: ((Bool) -> Void)?
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError("init") }
    
    private func setupCell() {
        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stockSwitch.onTintColor = .systemTeal
        stockSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        stockSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        contentView.addSubview(stockSwitch)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stockSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stockSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        nameLabel.font = .boldSystemFont(ofSize: 17)
        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .secondaryLabel
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "S/ \(product.price)"
        stockSwitch.isOn = product.isAvailable
        // Feedback visual: si no hay stock, el texto se vuelve gris
        nameLabel.alpha = product.isAvailable ? 1.0 : 0.5
    }
    
    @objc private func switchChanged() {
        onStockChange?(stockSwitch.isOn)
        nameLabel.alpha = stockSwitch.isOn ? 1.0 : 0.5
    }
}
