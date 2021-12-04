//
//  UIApplication+Ex.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 4/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit

extension UIApplication {
    var sceneDelegate: SceneDelegate {
       UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    }
    
    var authViewModel: AuthViewModel {
        sceneDelegate.austTravel.authViewModel
    }
}