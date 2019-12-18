//
//  Constants.swift
//  Will I Burn
//
//  Created by Elnur Rzayev on 12/09/2019.
//  Copyright © 2019 Elnur Rzayev. All rights reserved.
//

import Foundation

struct WeatherUrl {
    private let baseUrl = "http://api.weatherstack.com/current?"
    private let key = "access_key=506ce6c5effb2a76e37a08a6ae71f2c3"
    
    private var coordStr = "&query=fetch:ip"
    
//    init(lat: String, long: String) {
//        self.coordStr = " & query = \(lat), \(long)"
//
//    }
    
    func getFullUrl() -> String{
        return baseUrl + key + coordStr
    }
}

struct SkinType {
    let type1 = "Type 1 - Pale/Light"
    let type2 = "Type 2 - White/Fair"
    let type3 = "Type 3 - Medium"
    let type4 = "Type 4 - Olive Brown"
    let type5 = "Type 5 - Dark Brown"
    let type6 = "Type 6 - Very Dark/Black"
}

struct BurnTime {
    let burnTime1 : Double = 67
    let burnTime2 : Double = 100
    let burnTime3 : Double = 200
    let burnTime4 : Double = 300
    let burnTime5 : Double = 400
    let burnTime6 : Double = 500
}

struct defaultKeys {
    static let skinType = "skinType"
}
