//
//  SettingsView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 5/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import Defaults

struct SettingsView: View {
    
    @EnvironmentObject var austTravel: AUSTTravel
    @ObservedObject var settingsViewModel = UIApplication.shared.settingsViewModel
    
    
    @Default(.pingNotification) var pingNotification
    @Default(.locationNotification) var locationNotification
    @Default(.primaryBus) var primaryBus
    
    @State var buses = [Bus]()
    @State var selectedBusTime: String = ""
    @State var showBusSelect: Bool = false
    
    var body: some View {
        ZStack  {
            Color.white
            VStack {
                VStack {
                    Spacer()
                    Spacer()
                    HStack {
                        Icon(name: "back")
                            .iconColor(.white)
                            .clickable {
                                withAnimation {
                                    austTravel.currentPage = .home
                                }
                            }
                            .padding(.horizontal, 15.dWidth())
                            .padding(.trailing, 3.dWidth())
                        
                        Text("SETTINGS")
                            .scaledFont(font: .sairaCondensedBold, dsize: 25)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15.dWidth())
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(width: dWidth, height: 90.dHeight())
                .background(Color.green)
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Ping Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("If you don’t want to receive any ping notifications, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Toggle("", isOn: $pingNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Location Notification")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("If you don’t want to receive any notifications when someone is sharing their location, turn this off")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Toggle("", isOn: $locationNotification)
                                    .fixedSize()
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Primary Bus")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                    Text("Currently set to: \(primaryBus)")
                                        .lineLimit(nil)
                                        .scaledFont(font: .sairaCondensedRegular, dsize: 18)
                                    
                                }
                                .foregroundColor(.black)
                                Spacer()
                                Button {
                                    withAnimation(.easeIn) {
                                        showBusSelect.toggle()
                                    }
                                } label: {
                                    Text("CHANGE")
                                        .scaledFont(font: .sairaCondensedSemiBold, dsize: 20)
                                        .foregroundColor(.green)
                                }
                                
                            }
                            .padding(3.dHeight())
                            
                            Divider()
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading) {
                                Button {
                                    
                                } label: {
                                    Text("Privacy & Policy")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.black)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Contributors")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.black)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    
                                } label: {
                                    Text("Delete Account")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.redAsh)
                                }
                                .padding(3.dHeight())
                                
                                Divider()
                                    .foregroundColor(.black)
                                
                                Button {
                                    austTravel.logOut()
                                } label: {
                                    Text("Log Out")
                                        .scaledFont(font: .sairaCondensedBold, dsize: 23)
                                        .foregroundColor(.greenLight)
                                }
                                .padding(3.dHeight())
                            }
                            
                            Spacer()
                        }
                        .padding(10)
                        .padding(.horizontal, 10)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
            }
            if showBusSelect {
                SelectBusDailogue(buses: $buses, selectedBusName: $primaryBus, selectedBusTime: $selectedBusTime, display: $showBusSelect)
                    .transition(.scale)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            settingsViewModel.fetchBusInfo { busList in
                buses = busList
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
