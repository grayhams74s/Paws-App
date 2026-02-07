//
//  ContentView.swift
//  Paws
//
//  Created by felix angcot jr on 1/24/26.
//

import SwiftUI
import SwiftData
import TipKit


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var pets: [Pet]
    
    @State private var path = [Pet] ()
    @State private var isEditing: Bool = false
    
    let layout = [
        GridItem(.flexible(minimum: 120)),
        GridItem(.flexible(minimum: 120))
    ]
    
    let buttonTip = ButtonTip()
    
    func setUpTips(){
        do {
            // This command reset the tips data store to its initial state to the initial state
            //for retesting purpose
            try Tips.resetDatastore()
            // This will customize often our tip presented on our app after displaying another tip
            try Tips.configure([
                .displayFrequency(.daily)
            ])
        }catch {
            print("Error initilization Tip Kit \(error.localizedDescription)")
        }
    }
    
    init() {
        setUpTips()
    }
    
    func addPet() {
        let pet = Pet(name: "Best Friend")
        modelContext.insert(pet)
        path = [pet]
    }
    
    
    var body: some View {
        NavigationStack(path: $path){
            ScrollView{
                LazyVGrid(columns: layout){
                    GridRow{
                        ForEach(pets) { pet in
                            NavigationLink(value: pet){
                                VStack {
                                    
                                    if let imageData = pet.photo {
                                        if let image = UIImage(data: imageData){
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))
                                        }
                                        
                                        // Placeholder image if no valid photo
                                    } else {
                                        Image(systemName: "pawprint.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(40)
                                            .foregroundStyle(.quaternary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(pet.name)
                                        .font(.title.weight(.light))
                                        .padding(.vertical)
                                    
                                    Spacer()
                                }// : VStack
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .background(pet.photo == nil ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(Color.white))
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                                .overlay(alignment: .topTrailing){
                                    if isEditing {
                                        Menu {
                                            Button("Delete", systemImage: "trash", role: .destructive){
                                                modelContext.delete(pet)
                                                try? modelContext.save()
                                            }
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 36, height: 36)
                                                .foregroundStyle(.red)
                                                .symbolRenderingMode(.multicolor)
                                                .padding(4)
                                            
                                        }
                                    }
                                }
                                
                            }// :NAVLINK
                            // This code changes the link color from blue to primary color.
                            .foregroundStyle(.primary)
                        }// : LOOP
                    }//: GRID ROW
                }// : GRID LAYOUT
                .padding(.horizontal) // As you can see in the preview, this horizontal padding enhances our design even further
                EmptyView()
            }//: ScrollView
            .navigationTitle(pets.isEmpty ? "" : "Paws")
            .navigationDestination(for: Pet.self) { pet in
                EditPetView(pet: pet)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addPet()
                    })
                    {
                        Image(systemName: "plus.circle")
                            .foregroundStyle(Color.blue)
                        
                    }
                    .popoverTip(buttonTip)
                    
                    // We import TipKit to use this properties of TipKit
                }
            }
            .overlay {
                if pets.isEmpty {
                    CustomContentUnavailableView(icon: "dog.circle", title: "No Pets", description: "Add a new pet to get started.")
                }
            }
        } //:STACK
    }
}

#Preview("Sample Data"){
    ContentView()
        .modelContainer(Pet.preview)
}

#Preview ("No Data"){
    ContentView()
        .modelContainer(for: Pet.self, inMemory: true)
}
