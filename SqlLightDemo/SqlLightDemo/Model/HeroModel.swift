//
//  HeroModel.swift
//  SqlLightDemo
//
//  Created by Yagnik Suthar on 27/03/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

class HeroModel {
 
    var id: Int
    var name: String?
    var powerRanking: Int
 
    init(id: Int, name: String?, powerRanking: Int){
        self.id = id
        self.name = name
        self.powerRanking = powerRanking
    }
}
