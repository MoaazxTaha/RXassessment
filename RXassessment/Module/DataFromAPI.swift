//
//  cellContians.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 09/01/2022.
//

import Foundation

struct DataFromAPI : Codable {
    let page : Int?
    let per_page : Int?
    let photos : [Photos]?
    let total_results : Int?
    let next_page : String?
}

struct Photos : Codable {
    let id : Int?
    let width : Int?
    let height : Int?
    let url : String?
    let photographer : String?
    let photographer_url : String?
    let photographer_id : Int?
    let avg_color : String?
    let src : Src?
    let liked : Bool?
    let alt : String?
}

struct Src : Codable {
    let original : String?
    let large2x : String?
    let large : String?
    let medium : String?
    let small : String?
    let portrait : String?
    let landscape : String?
    let tiny : String?
}
