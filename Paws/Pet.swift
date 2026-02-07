//
//  Pet.swift
//  Paws
//
//  Created by felix angcot jr on 1/24/26.
//

import Foundation
import SwiftData

@Model
final class Pet {
    var name: String
    // External Storage attribute which we added to the photos property
    // The external storage attribute stores the property's value as binary data a json to the model storage.
    // The Pet photo is optional and not mandatory. This means user do not need to add a photo each time they create new pet.
    @Attribute(.externalStorage) var photo: Data?
    
    
    init(name: String, photo: Data? = nil) {
        self.name = name
        self.photo = photo
    }
}

extension Pet {
    @MainActor
    static var preview: ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Pet.self, configurations: configuration)
        
        container.mainContext.insert(Pet(name: "Rexy"))
        container.mainContext.insert(Pet(name: "Bella"))
        container.mainContext.insert(Pet(name: "Charlie"))
        container.mainContext.insert(Pet(name: "Daisy"))
        container.mainContext.insert(Pet(name: "Fido"))
        container.mainContext.insert(Pet(name: "Gus"))
        container.mainContext.insert(Pet(name: "Mimi"))
        container.mainContext.insert(Pet(name: "Luna"))
        
        return container
    }
}
