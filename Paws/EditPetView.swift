//
//  EditPetView.swift
//  Paws
//
//  Created by felix angcot jr on 1/24/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPetView: View {
    @Environment(\.dismiss) private var dismiss
    // Bindable property is that we use this property wrapper to create bindings
    // To mutuable properties of a data model object that conforms to the observable
    @Environment(\.modelContext) var modelContext
    @Bindable var pet: Pet
    @State private var photosPickerItem: PhotosPickerItem?
    var body: some View {
        Form {
            
            // MARK: -- IMAGE
            
            if let imageData = pet.photo{
                if let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                        .padding(.top)
                }
            } else {
                CustomContentUnavailableView(icon: "pawprint.circle", title: "No Photo" , description: "Add a photo of your favorite photo pet to make it easier to find them.")
                    .padding(.top)
            }
            
            // MARK: -- PHOTO PICKER
            
            PhotosPicker(selection: $photosPickerItem, matching: .images){
                Label("Select a photo", systemImage: "photo.badge.plus")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
             
            .listRowSeparator(.hidden)
            
            // MARK: -- TEXT FIELD
            
            TextField("Name", text: $pet.name)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle.weight(.light))
                .padding(.vertical)
            
            // MARK: -- BUTTON
            Button {
                dismiss()
                
            } label: {
                Text("Save")
                    .font(.title3.weight(.medium))
                    .padding(8)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .listRowSeparator(.hidden)
            .padding(.bottom)
            
        } //: FORM
        .listStyle(.plain)
        .navigationTitle("Edit \(pet.name)")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: photosPickerItem){
            Task {
                pet.photo = try? await photosPickerItem?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    NavigationStack {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try! ModelContainer(for: Pet.self, configurations: configuration)
            let sampleData = Pet(name: "Daisy")
            
            return EditPetView(pet: sampleData)
                .modelContainer(container)
        } catch {
            fatalError("Could not load the preview data. \(error.localizedDescription)")
        }
    }
}


