//
//  SwiftUICoreDataSpendingTrackerApp.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Amaechi Chukwu on 08/12/2022.
//

import SwiftUI

@main
struct SwiftUICoreDataSpendingTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
