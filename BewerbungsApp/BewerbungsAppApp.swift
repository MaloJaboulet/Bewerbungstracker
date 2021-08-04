//
//  BewerbungsAppApp.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 18.03.21.
//

import SwiftUI

@main
struct BewerbungsAppApp: App {
    @StateObject private var liste = BewerbungsListe()
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            StartSeiteBewerbung(liste: liste)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)   
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
