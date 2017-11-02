//
//  CoreDataHelp.swift
//  Pokemon
//
//  Created by Ryan Chingway on 11/2/17.
//  Copyright © 2017 Ryan Chingway. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon () {
    
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Caterpie", imageName: "caterpie")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Mankey", imageName: "mankey")
    createPokemon(name: "Eevee", imageName: "eevee")
    createPokemon(name: "Abra", imageName: "abra")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func createPokemon (name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}

func getAllPokemon () -> [Pokemon] {
    
    do {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
        
    } catch {}
    
    return []
}

func getAllCaughtPokemons () -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []
}

func getAllUncaughtPokemons () -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []
}

