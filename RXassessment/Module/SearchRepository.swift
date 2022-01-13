//
//  SearchRepository.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 12/01/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRepository {
    var searchBar : BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    var searchText :  BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    var searchList = SearchList()
    var SearchState : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var requestedPictures : BehaviorRelay<[Photos]> = BehaviorRelay(value: [])
}

struct SearchList {
    var descriptions : [String] = []
    var titles : [String] = []
}
