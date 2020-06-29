//
//  LocationManager.swift
//  PorpertyMgr
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreLocation

//possible errors
enum OneShotLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

class OneShotLocationManager: NSObject, CLLocationManagerDelegate {
    
    //location manager
    private var locationManager: CLLocationManager?
    
    

    private var didComplete : (_ response:CLLocation?, _ error: Error? ) -> Void = {_,_ in }
    
    
    
    //location manager returned, call didcomplete closure
    private func _didComplete(location: CLLocation?, error: NSError?) {
        locationManager?.stopUpdatingLocation()

            didComplete(location , error)
            
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        _didComplete(location: location, error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        _didComplete(location: nil, error: error as NSError)
    }
    
    func fetchWithCompletion(completion: @escaping(_ response:CLLocation?, _ error: Error? ) -> Void ) {
        //store the completion closure
        didComplete = completion
        
        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestLocation()
        
    }
}
