//
//  Address.swift
//  firstApp
//
//  Created by ChinhPV on 3/6/21.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import Foundation
import MapKit
class Address {
    var address : String
    init? (address: String){
        guard !address.isEmpty else {
            return nil
        }
        self.address = address
    }
    
    func getLocation(address: String) -> CLLocation{
        var lat: Double = 0
        var long: Double = 0
        coordinates(forAdress: address){
            (location) in
            guard let location = location else {
                print("Get location failed. Set location default to Hanoi")
                lat = 21.0278
                long = 105.8342
                return
            }
            lat = location.latitude
            long = location.longitude
        }
        return CLLocation(latitude: lat, longitude: long)
        
    }
    
    
    func getAddress(latitude: Double, longtitude: Double) -> String {
        var address : String = ""
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
                let pm = placemarks![0]
                address+=pm.thoroughfare!
                address+=", "
                address+=pm.subLocality!
                address+=", "
                address+=pm.locality!
                address+=", "
                address+=pm.country!
            }
        })
        return address
    }
    //Private func
    private func coordinates(forAdress address: String, completion: @escaping (CLLocationCoordinate2D?)-> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address){
                (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
}
