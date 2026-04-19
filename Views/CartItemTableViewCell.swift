//
//  CartItemDelegate.swift
//  HealthyGO
//
//  Created on 18/04/26.
//


import UIKit

// Protocolo para comunicar acciones al ViewController
protocol CartItemDelegate: AnyObject {
    func didUpdateQuantity(for product: Product, newQuantity: Int)
    func didRemoveProduct(_ product: Product)
}

final class CartItemTableViewCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
    weak var delegate: CartItemDelegate?
    private var currentProduct: Product?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with item: CartItem) {
        self.currentProduct = item.product
        nameLabel.text = item.product.name
        priceLabel.text = String(format: "S/ %.2f c/u", item.product.price)
        quantityLabel.text = "\(item.quantity)"
    }
    
    @objc private func minusTapped() {
        guard let product = currentProduct, let currentQty = Int(quantityLabel.text ?? "0") else { return }
        delegate?.didUpdateQuantity(for: product, newQuantity: currentQty - 1)
    }
    
    @objc private func plusTapped() {
        guard let product = currentProduct, let currentQty = Int(quantityLabel.text ?? "0") else { return }
        delegate?.didUpdateQuantity(for: product, newQuantity: currentQty + 1)
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),
            
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            minusButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
