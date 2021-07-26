//
//  AddressViewController.swift
//  firstApp
//
//  Created by ChinhPV on 3/6/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//
import os.log
import UIKit
import MapKit


class AddressViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {

    //property
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressMapView: MKMapView!
    @IBOutlet weak var saveAddress: UIBarButtonItem!
    
    //var
    var updateAddress : ((_ address: String) -> Void)?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            addressMapView.delegate = self as? MKMapViewDelegate
            addressTextView.delegate = self
            textViewInit()
        }
    
    //TextView func
    private func textViewInit () {
        addressTextView.text = "Choose address from below"
        addressTextView.textColor = UIColor.lightGray
        addressTextView.layer.borderWidth = 1
        addressTextView.layer.borderColor = UIColor.lightGray.cgColor
        addressTextView.layer.cornerRadius = 2.5
    }

    //Private functions
    @IBAction func confrmBtn(_ sender: Any) {
        self.updateAddress?(self.addressTextView.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getLongPressedLocation(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        let touchLocation = sender.location(in: addressMapView)
        let location = addressMapView.convert(touchLocation, toCoordinateFrom: addressMapView)
        getAddress(latitude: location.latitude, longtitude: location.longitude)
        print("Map long pressed at : \(location.latitude), \(location.longitude)")
    }
    
    private func getAddress(latitude: Double, longtitude: Double){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo : CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longtitude
        
        let location : CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            if ( error != nil){
                print("Get location failed")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                var address: String = ""
                let pm = placemarks![0]
                print("Map: ",pm.name ?? "No place name")
                print("Map: ",pm.thoroughfare ?? "No street number")
                print("Map: ",pm.subLocality ?? "")
                print("Map: ",pm.locality ?? "")
                print("Map: ",pm.country ?? "")
                
                if pm.name != nil {
                    address += "\(pm.name!), "
                }
                address += "\(pm.subThoroughfare ?? ""), "
                address += "\(pm.subLocality ?? ""), "
                address += "\(pm.locality ?? ""), "
                address += "\(pm.country ?? "")"
                self.addressTextView.text = address
                self.addressTextView.textColor = UIColor.black
                print("Map address: \(address)")
            }
        })
        let anno: MKPointAnnotation = MKPointAnnotation()
        anno.coordinate = center
        if addressMapView.annotations.count != 0 {
            addressMapView.removeAnnotations(addressMapView.annotations)
        }
        addressMapView.addAnnotation(anno)
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
