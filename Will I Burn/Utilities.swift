//
//  Utilities.swift
//  Will I Burn
//
//  Created by Elnur Rzayev on 11/09/2019.
//  Copyright © 2019 Elnur Rzayev. All rights reserved.
//

import Foundation

class Utilities {
    
    func getStorage() -> UserDefaults{
        return UserDefaults.standard
    }
    
    func setSkinType(value: String){
        let defaults = getStorage()
        defaults.set(value, forKey: defaultKeys.skinType)
        defaults.synchronize()
    }
    
    func getSkinType() -> String{
        let defaults = getStorage()
        if let result = defaults.string(forKey: defaultKeys.skinType){
        return result
        }
        return SkinType().type1
    }
}



