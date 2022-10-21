import SwiftUI

class PokemonViewModel: ObservableObject {
    @Published var offset = 0
    @Published var pokemons = [PokemonData]() // data in gridView
    var pokemonList = [Pokemon]() // used internally for list of pokemon and its url for rest of data
    var pokemonListURL = "https://pokeapi.co/api/v2/pokemon?limit=18&offset="
    
    
    // Load pokemon list - Miletone 1
    func getPokemonList(completion: @escaping (Result<PokemonList, Error>) -> Void) {
        guard let url = URL(string: pokemonListURL + String(offset)) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching pokemon list: \(String(describing: error))")
                return
            }
            do {
                let pokemonBatch = try JSONDecoder().decode(PokemonList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(pokemonBatch))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func getPokemonData(pokemonURL: String, completion: @escaping (Result<PokemonData, Error>) -> Void) {
        guard let url = URL(string: pokemonURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("error fetching pokemonData: \(String(describing: error))")
                return
            }
            do {
                let pokemonBatch = try JSONDecoder().decode(PokemonData.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(pokemonBatch))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func updatePokemonBatchData() {
        getPokemonList { [self] (result) in
            switch result {
            case .success(let pokemonBatch):
                pokemonList.append(contentsOf: pokemonBatch.results) // add new pokemon data
                offset += 18
                
                // for latest 18 pokemon, populate pokemonDataList with  id, name, image
                let latestPokemonBatch = pokemonList.suffix(18)
                for pokemon in latestPokemonBatch {
                    getPokemonData(pokemonURL: pokemon.url) { (result) in
                        switch result {
                        case .success(let pokemonData):
                            self.pokemons.append(pokemonData)
                            self.pokemons.sort(by: {$0.id < $1.id})
                        case .failure(let error):
                            print("Error processing json data: \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    // handle pagination - Milestone 2
    func loadAnotherBatch(currentPokemonIndex: Int){
        if currentPokemonIndex >= 18 {
            let thresholdIndex = self.pokemons.endIndex
            if currentPokemonIndex == thresholdIndex && pokemons.count < 1154 {
                updatePokemonBatchData()
            }
        }
    }
}

