//
//  ContentView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 30/11/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @EnvironmentObject var networkReachability: NetworkReachability
    
    var body: some View {

        if networkReachability.reachable {
            if austTravel.currentAuthPage == .none {
                if austTravel.currentPage == .home {
                    HomeView()
                        .transition(.move(edge: .trailing))
                } else  if austTravel.currentPage == .liveTrack {
                    LiveTrackView()
                        .transition(.move(edge: .trailing))
                } else  if austTravel.currentPage == .settings {
                    SettingsView()
                        .transition(.move(edge: .trailing))
                } else if austTravel.currentPage == .privacyPolicy {
                    PrivacyPolicyView()
                        .transition(.move(edge: .trailing))
                }
            } else {
                AuthView()
            }
        } else {
            NoNetView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
