//
//  HomeViewModel.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit
import Defaults
import CoreLocation.CLLocation

class HomeViewModel: ObservableObject {
    
    private var database = Database.database()
    let austTravel = UIApplication.shared.sceneDelegate.austTravel
    
    @discardableResult
    func updateLocationSharing() -> Bool {
        
        if austTravel.isLocationSharing {
            austTravel.locationManager.stopUpdatingLocation()
        } else {
            austTravel.locationManager.startUpdatingLocation()
        }
        
        austTravel.isLocationSharing.toggle()
        return austTravel.isLocationSharing
    }
    
    func getVolunteerInfo(completion: @escaping (Volunteer?, Error?) -> ()) {
        
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)").getData { [weak self] error, snapshot in
            guard let self = self else { return }
            if error != nil {
                completion(nil, error)
                return
            }
            
            var volunteer = Volunteer()
            guard let dict = snapshot.value as? NSDictionary else { return }
            volunteer.contact = dict["contact"] as? String ?? ""
            volunteer.status = dict["status"] as? Bool ?? false
            volunteer.totalContribution = dict["totalContribution"] as? Int ?? 0
            
            self.database.reference(withPath: "users/\(self.austTravel.currentUserUID!)").getData { error, snapshot in
                if error != nil {
                    completion(nil, error)
                    return
                }
                guard let dict = snapshot.value as? NSDictionary else { return }
                var userInfo = UserInfo()
                userInfo.department = dict["department"] as? String ?? ""
                userInfo.email = dict["email"] as? String ?? ""
                userInfo.userName = dict["name"] as? String ?? ""
                userInfo.semester = dict["semester"] as? String ?? ""
                userInfo.universityId = dict["universityId"] as? String ?? ""
                
                volunteer.userInfo = userInfo
                Defaults[.userInfo] = userInfo
                
                Defaults[.volunteer] = volunteer
                Defaults[.userInfo] = userInfo
                
                completion(volunteer, nil)
            }
        }
    }
    
    func updateBusLocation(selectedBusName: String, selectedBusTime: String, _ currentCoordinate: CLLocationCoordinate2D) {
        
        var dict = [String: String]()
        dict["lat"] = String(currentCoordinate.latitude)
        dict["long"] = String(currentCoordinate.longitude)
        dict["lastUpdatedTime"] = String(Int(Date().timeIntervalSince1970 * 1000))
        dict["lastUpdatedVolunteer"] = austTravel.currentUserUID!
    
        database.reference(withPath: "bus/\(selectedBusName)/\(selectedBusTime)/location")
            .setValue(dict)
    }
    
    func fetchBusInfo(completion: @escaping ([Bus]) -> ()) {
        var buses = [Bus]()
        
        database.reference(withPath: "availableBusInfo").getData { error, snapshot in
            if error != nil {
                completion(buses)
                return
            }
           
            snapshot.children.forEach { dict in
                let snap = dict as! DataSnapshot
                var bus = Bus()
                bus.name = String(snap.key)
                snap.children.forEach { dict in
                    bus.timing.append(BusTiming(snapshot: dict as! DataSnapshot))
                }
                buses.append(bus)
            }
            completion(buses)
        }
    }
    
    func updateContribution(elapsedTime: Int) {
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)/totalContribution").keepSynced(true)
         var previousContribution = 0
        database.reference(withPath: "volunteers/\(austTravel.currentUserUID!)/totalContribution").getData { [weak self] error, snapshot in
            guard let self = self else {  return }
            if error != nil {
                return
            }
            
            if snapshot.exists() {
                previousContribution = (snapshot.value as! Int)
                print("previousContribution", previousContribution)
            }
            
            let totalTimeElapsed = previousContribution + (elapsedTime * 1000)
            print("totalTimeElapsed", totalTimeElapsed)
            self.database.reference(withPath: "volunteers/\(self.austTravel.currentUserUID!)/totalContribution").setValue(totalTimeElapsed)
        }
        
    }
}


