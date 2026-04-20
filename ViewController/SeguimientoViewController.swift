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
        label.text = "Cocinando tu pedido... 🍳"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Nueva Barra de Progreso
    private let progressBar: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.progressTintColor = .systemGreen
        pv.trackTintColor = .systemGray5
        pv.progress = 0.2
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configurarMapaSimulado()
        iniciarSimulacionMejorada()
    }

    private func setupUI() {
        title = "Seguimiento en Vivo"
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(mapView)
        view.addSubview(statusCard)
        statusCard.addSubview(statusLabel)
        statusCard.addSubview(progressBar)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),

            statusCard.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusCard.heightAnchor.constraint(equalToConstant: 130),

            statusLabel.topAnchor.constraint(equalTo: statusCard.topAnchor, constant: 25),
            statusLabel.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -20),

            progressBar.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 30),
            progressBar.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -30),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    private func configurarMapaSimulado() {
        let localizacionTienda = CLLocationCoordinate2D(latitude: -12.046374, longitude: -77.042793)
        let region = MKCoordinateRegion(center: localizacionTienda, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.title = "HealthyGo Kitchen"
        pin.coordinate = localizacionTienda
        mapView.addAnnotation(pin)
    }

    private func iniciarSimulacionMejorada() {
        // Estado 1: Preparación (Ya iniciado)
        
        // Estado 2: En Camino
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            UIView.animate(withDuration: 0.5) {
                self.statusLabel.text = "¡El repartidor está en camino! 🛵"
                self.statusLabel.textColor = .systemBlue
                self.progressBar.setProgress(0.7, animated: true)
                self.mapView.subviews.first?.alpha = 0.8 // Efecto visual simple
            }
        }

        // Estado 3: Entregado
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            UIView.animate(withDuration: 0.5) {
                self.statusLabel.text = "¡Llegó tu pedido! 🥗"
                self.statusLabel.textColor = .systemGreen
                self.progressBar.setProgress(1.0, animated: true)
            }
            self.finalizarSeguimiento()
        }
    }

    private func finalizarSeguimiento() {
        let alert = UIAlertController(title: "¡Buen provecho!", message: "Tu pedido HealthyGo ha sido entregado con éxito.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ir al Inicio", style: .default) { _ in
            // Volvemos a la pantalla principal (TabBar)
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
