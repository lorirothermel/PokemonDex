//
//  CreaturesViewModel.swift
//  PokemonDex
//
//  Created by Lori Rothermel on 6/2/23.
//

import Foundation

@MainActor
class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?    
        var results: [Creature]
    }  // struct
            
    @Published var creaturesArray: [Creature] = []
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var count = 0
    @Published var isLoading = false
    
    
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLoading = true
        
        // Convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("❗️ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }  // guard let
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("❗️ERROR: Could not decode returned JSON data.")
                isLoading = false
                return
            }  // guard let
            
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray = self.creaturesArray + returned.results
            isLoading = false
        } catch {
            print("❗️ERROR: Could not find URL at \(urlString) to get data and response.")
            isLoading = false
        }  // do...catch
    }  // getData
    
    
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else { return }
        
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
            Task {
                await getData()
            }  // Task
        }  // if
    }
        
    
    func loadAll() async {
        
        guard urlString.hasPrefix("http") else { return }
        
        await getData()
        await loadAll()
        
    }  // loadAll
    
    
    
}  // CreaturesViewModel
