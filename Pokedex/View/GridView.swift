//
//  GridView.swift
//  Pokedex
//
//  Created by Vincent Nguyen on 10/21/22.
//

import SwiftUI

struct GridView: View {
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var pokemonVM = PokemonViewModel()
    @State var highlightedPokemonURL = ""
    @State var highlightedPokemonName = ""
    var body: some View {
        VStack {
            if highlightedPokemonURL != "" {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(hex: 0x7ebf61))
                        .frame(height: 200)
                    VStack {
                        AsyncImage(url: URL(string: highlightedPokemonURL))
                            .scaleEffect(2.0)
                            .frame(height: 140)
                        Text(highlightedPokemonName)
                    }
                        
                }
                .cornerRadius(30)
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(hex: 0x7ebf61))
                        .frame(height: 200)
                    Text("No pokemon selected")
                }
                .cornerRadius(30)
            }
            
            ScrollView {
                LazyVGrid(columns: gridItems) {
                    ForEach(pokemonVM.pokemons) { pokemon in
                        
                        VStack(spacing: -10) {
                            AsyncImage(url: URL(string: pokemon.sprites.front_default))
                                .frame(height: 120)
                        }
                        
                        .onTapGesture {
                            highlightedPokemonURL = pokemon.sprites.front_default
                            highlightedPokemonName = pokemon.name
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: highlightedPokemonName == pokemon.name ? 5 : 0)
                        )
                        .onAppear { // pagination
                            pokemonVM.loadAnotherBatch(currentPokemonIndex: pokemon.id)
                        }
                        
                    }
                }
                .padding(10)
            }
            .background(.white)
            .cornerRadius(30)
            
        }
        .padding(10)
        
        .onAppear {
            pokemonVM.updatePokemonBatchData()
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
