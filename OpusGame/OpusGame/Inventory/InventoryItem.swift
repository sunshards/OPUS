//
//  InventoryItem.swift
//  OpusTV
//
//  Created by Andrea Iannaccone on 06/03/25.
//

import SpriteKit

var isAddable : [String : Bool] =
[
    "acqua" : true,
    "boccia" : false,
    "bocciasangue" : true,
    "chiave" : false,
    "fiore" : true,
    "mestolo" : false,
    "veleno" : true
]

struct InventoryItem {
    var name: String
    var isAdded : Bool = false
}

//enum Item : String {
//    case acqua = "acqua"
//    case boccia = "boccia"
//    case bocciasangue = "bocciasangue"
//    case chiave = "chiave"
//    case fiore = "fiore"
//    case mestolo = "mestolo"
//    case veleno = "veleno"
//}
