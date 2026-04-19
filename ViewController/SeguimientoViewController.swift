//
//  SeguimientoViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import MapKit

final class SeguimientoViewController: UIViewController {

    // MARK: - UI Elements
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 20
        map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    private let statusCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Preparando tu pedido saludable..."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemTeal
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configurarMapaSimulado()
        iniciarSimulacion()
    }

    private func setupUI() {
        title = "Ruta de Entrega"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(mapView)
        view.addSubview(statusCard)
        statusCard.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            // Mapa en la parte superior
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            // Tarjeta de estado debajo del mapa
            statusCard.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusCard.heightAnchor.constraint(equalToConstant: 100),

            statusLabel.centerYAnchor.constraint(equalTo: statusCard.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -20)
        ])
    }

    private func configurarMapaSimulado() {
        // Coordenadas simuladas (Lima como ejemplo)
        let localizacionInicial = CLLocationCoordinate2D(latitude: -12.046374, longitude: -77.042793)
        
        // CORRECCIÓN AQUÍ: Cambiamos los nombres de los parámetros
        let region = MKCoordinateRegion(
            center: localizacionInicial,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )
        
        mapView.setRegion(region, animated: true)

        // Marcador del repartidor
        let repartidorPin = MKPointAnnotation()
        repartidorPin.title = "Tu Repartidor HealthyGo"
        repartidorPin.coordinate = localizacionInicial
        mapView.addAnnotation(repartidorPin)
    }

    private func iniciarSimulacion() {
        // Simulación de cambio de estados
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.statusLabel.text = "¡El repartidor está en camino! 🛵"
            self.statusLabel.textColor = .systemBlue
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            self.statusLabel.text = "¡Pedido entregado! Buen provecho 🥗"
            self.statusLabel.textColor = .systemGreen
            self.finalizarSeguimiento()
        }
    }

    private func finalizarSeguimiento() {
        let alert = UIAlertController(title: "¡Disfruta tu comida!", message: "Esperamos que tu experiencia en HealthyGo haya sido excelente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Finalizar", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
