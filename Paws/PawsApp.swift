//
//  PawsApp.swift
//  Paws
//
//  Created by felix angcot jr on 1/24/26.
//

import SwiftUI
import SwiftData

@main
struct PawsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            // This code sets the model container in this view to store the provided model type
            // It also create a new container if necessary, and sets a model context for it in this view's environment
                .modelContainer(for: Pet.self)
        }
    }
}
