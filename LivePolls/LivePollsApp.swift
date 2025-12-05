//
//  LivePollsApp.swift
//  LivePolls
//
//  Created by Balogun Kayode on 04/11/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore


//init firebaseapp
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let settings =  Firestore.firestore().settings
//        dummy server
        settings.host = "127.0.0.1:8080"
        settings.cacheSettings = MemoryCacheSettings()
        //   ............     dummy server

        
        Firestore.firestore().settings = settings
        return true
    }
}

@main
struct LivePollsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


//vote creating a poll and inviting users to join  an existing poll by id
//more features include, deep linking, live activities, real time data base, platform vison os, macos and watchOS compatible and Push Notification Service, Live Activity Widget
//invite people to join poll using the poll id and deeplinking
//every user activity should be logged

