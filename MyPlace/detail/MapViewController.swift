//
//  MapViewController.swift
//  MyPlace
//
//  Created by Я on 01/09/2020.
//  Copyright © 2020 HomeMade. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc protocol MapViewControllerDelegate {
    @objc optional func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    var mapViewControllerDelegat: MapViewControllerDelegate? 
    var place = Place()
    var annotationIdentifire = "annotationIdentifire"
    let locationManager = CLLocationManager()
    let accuracyLocation = 10_000.00
    var tapSegueIdentifier = ""
    var placeCoordinate: CLLocationCoordinate2D?
    
    
    @IBOutlet weak var currentAddress: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var userLocationPin: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getDirection: UIButton!
    
    @IBAction func centerViewUserLocation() {
        showUserLocation()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegat?.getAddress?(currentAddress.text)
        dismiss(animated: true)
    }
   
    @IBAction func goButton() {
        getDirections()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAddress.text = ""
        mapView.delegate = self
        setupMapView()
        checkLocationServices()
    }
    
    private func setupMapView() {
        
        getDirection.isHidden = true
        
        if tapSegueIdentifier == "showMap" {
            setupLocation()
            userLocationPin.isHidden = true
            currentAddress.isHidden = true
            doneButton.isHidden = true
            getDirection.isHidden = false
        }
    }
    
    private func setupLocation() {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotaton = MKPointAnnotation()
            annotaton.title = self.place.name
            annotaton.subtitle = self.place.type
            guard let placeMarkLocation = placemark?.location else { return }
            
            annotaton.coordinate = placeMarkLocation.coordinate
            self.placeCoordinate = placeMarkLocation.coordinate
            
            self.mapView.showAnnotations([annotaton], animated: true)
            self.mapView.selectAnnotation(annotaton, animated: true)
            
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            locationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Location Services are Disabled",
                    message: "To enable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self 
    }
    
    private func locationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if tapSegueIdentifier == "getAddress" { showUserLocation() }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(
                    title: "Your Location is not Available",
                    message: "To give permission Go to: Setting -> MyPlaces -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case")
        }
    }
    private func showUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: accuracyLocation, longitudinalMeters: accuracyLocation)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getDirections() {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        guard let request = createDirectionRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return
            }
            
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let timeInterval = route.expectedTravelTime
                
                print("Расстояние до места: \(distance) км.")
                print("Время в пути составит: \(timeInterval) сек.")
            }
        }
    }
    
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {

        guard  let destinationCoordinate = placeCoordinate else { return nil }
        let startLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
         
         let latitude = mapView.centerCoordinate.latitude
         let longitude = mapView.centerCoordinate.longitude
         
         return CLLocation(latitude: latitude, longitude: longitude)
     }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationIdentifire") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            annotationView?.canShowCallout = true
        }
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
            
        }
        return annotationView
    }
    
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
            let center = getCenterLocation(for: mapView)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let placemarks = placemarks else { return }
                
                let placemark = placemarks.first
                let streetName = placemark?.thoroughfare
                let buildNumber = placemark?.subThoroughfare
                
                DispatchQueue.main.async {
                    
                    if streetName != nil && buildNumber != nil {
                        self.currentAddress.text = "\(streetName!), \(buildNumber!)"
                    } else if streetName != nil {
                        self.currentAddress.text = "\(streetName!)"
                    } else {
                        self.currentAddress.text = ""
                    }
                }
            }
        }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorization()
    }
}
