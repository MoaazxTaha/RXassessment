//
//  TableViewModel.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 09/01/2022.
//

import Foundation
import RxSwift
import RxCocoa

class TableViewModel {
    let auth = "563492ad6f91700001000001db43b2c8f7654581b8b9cf045e26721c"
    let url = "https://api.pexels.com/v1/search?query=people"
    var fetchedPictures : BehaviorRelay<[Photos]> = BehaviorRelay(value: [])
    let searchRepository = SearchRepository()
    let disposeBag = DisposeBag()
    
    
    init() {
        self.searchResult()
    }
}
//MARK: - URL Session

extension TableViewModel {
    
    func fetchData()  {
        let url = URL(string: url)
        
        let session = URLSession(configuration: .default)
        
        var Request = URLRequest.init(url: url!)
        Request.addValue(auth, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: Request) { [self]
            (Data, URLResponse, Error) in
            
            if let err = Error {
                print(err.localizedDescription)
            }
            
            if let data = Data {
                
                let decoded = self.decodeData(Data: data)
                if let data = decoded?.photos {
                    self.fetchedPictures.accept(data)
                }
            }
            
        }
        task.resume()
    }
}

//MARK: - Decoded Data

extension TableViewModel {
    private func decodeData(Data:Data)-> DataFromAPI? {
        
        let decoder = JSONDecoder()
        
        do {
            let dataDecoded = try decoder.decode(DataFromAPI.self, from: Data)
            return dataDecoded
        }
        catch let error {
            print(String(describing: error)) // <- ✅ Use this for debuging!
            return nil
        }
    }
}
//MARK: - Search Handling

extension TableViewModel {
    
    
    func prepareSearchText(searchText:String)->String {
        let textWithoutSpaces = searchText.removingSpaces
        return textWithoutSpaces.lowercased()
    }
    
    func searchResult() {
        let combinedSignal =  Observable.combineLatest(searchRepository.searchText, self.fetchedPictures)
        
        combinedSignal
            .filter({!$0.1.isEmpty})
            .map({ (term, fetchedPictures) in
                return fetchedPictures.filter({
                    term.isEmpty ||
                        ($0.photographer!.searchable().contains(term)) ||
                        (($0.alt!.searchable().contains(term)))
                })
            })
            .distinctUntilChanged()
            .bind(to: searchRepository.filteredPictures)
            .disposed(by: disposeBag)
    }
    
}

extension String {
    func searchable() -> String {
        return self.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
