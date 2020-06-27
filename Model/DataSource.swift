//
//  DataSource.swift
//  Clipboard Test
//
//  Created by Raz on 06/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import Foundation

class DataSource {
    
//    var countries: Countries?
    var countries = [Country]()
    
    
    //    let url = URL(string: "https://api.jsonbin.io/b/5edb506b655d87580c44d405")
    
    let url = URL(string: "https://gist.githubusercontent.com/anubhavshrimal/75f6183458db8c453306f93521e93d37/raw/f77e7598a8503f1f70528ae1cbf9f66755698a16/CountryCodes.json")
    
    public func parseCountriesFromJson(completion: @escaping ([Country]) -> ()) {
        if let url = url {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        self.countries = try
                            JSONDecoder().decode([Country].self, from: data)
                        completion(self.countries)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
}
