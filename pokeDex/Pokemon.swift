//
//  Pokemon.swift
//  pokeDex
//
//  Created by Oscar Arnaiz on 21/06/2016.
//  Copyright © 2016 Oscar Arnaiz. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon  {
    private var _name:String!
    private var _pokedexId:Int!
    private var _description: String!
    private var _type: String!
    private var _defense:Int!
    private var _height:String!
    private var _weight:String!
    private var _attack:Int!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLvl:String!
    private var _pokemonURL: String!
    
    var name:String {
        return _name
    }
    var pokedexId:Int {
        return _pokedexId
    }
    var weight:String {
        return _weight
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type:String {
        return _type
    }
    var defense:Int {
        return _defense
    }
    var height:String {
        return _height
    }
    var attack:Int {
        return _attack
    }
    var nextEvolutionTxt: String{
        return _nextEvolutionTxt
    }
    var nextEvolutionId: String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLvl:String{
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    init(name:String, pokedexId:Int){
        self._name = name
        self._pokedexId = pokedexId
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonURL)
        
        Alamofire.request(.GET, url!).responseJSON { response in
            let result = response.result
            
            if let dic = result.value as? Dictionary<String, AnyObject> {
                if let weight = dic["weight"] as? String {
                    self._weight = weight
                } else {
                    self._weight = ""
                }
                if let height = dic["height"] as? String {
                    self._height = height
                } else {
                    self._height = ""
                }
                if let attack = dic["attack"] as? Int {
                    self._attack = attack
                } else {
                    self._attack = 0
                }
                if let defense = dic["defense"] as? Int {
                    self._defense = defense
                } else {
                    self._defense = 0
                }
            
                if let types = dic["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    var typesStrings=""
                    if let name = types[0]["name"] {
                        typesStrings = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name =  types[x]["name"] {
                                typesStrings += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    self._type = typesStrings
                    
                } else {
                    self._type = ""
                }
                
                if let descArray = dic["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0 {
                    if let urlDesc = descArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(urlDesc)")!
                        
                         Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            completed()
                            
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evoArray = dic["evolutions"] as? [Dictionary<String, AnyObject>] where evoArray.count > 0 {
                    if let to = evoArray[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            if let uri = evoArray[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let nextPokemonID = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = nextPokemonID
                                self._nextEvolutionTxt = to
                            }
                            if let level = evoArray[0]["level"] as? Int {
                                self._nextEvolutionLvl = "\(level)"
                            }
                        }
                    }
                } else {
                    self._nextEvolutionTxt = ""
                }
                completed()
            }
        }
    }
}
