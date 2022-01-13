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
    var fitchedData : BehaviorRelay<[Photos]> = BehaviorRelay(value: [])
    let searchRepository = SearchRepository()
    let disposeBag = DisposeBag()


init () {
    self.searchRequest()
   self.prepareSearchList(searchList: fitchedData.value)
   self.searchResult()
}
}
//MARK: - URL Session

extension TableViewModel {
    
    func fetchData (handler: @escaping ()->Void)  {
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
                    self.fitchedData.accept(data)
                    if searchRepository.SearchState.value == false{
                        self.searchRepository.requestedPictures.accept(data)
                        handler()
                    } else {
                        searchResult()
                    }
                }
            }
            else {
                handler()
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
    
    
    func searchRequest() {
        
//        guard searchRepository.searchBar.value != "" else {return false}
        
//         searchRepository.searchBar.asObservable().subscribe({ searchtext in
//
//            if self.searchRepository.searchBar.value != "" {
//                let value = searchtext.element.map{
//                    self.prepareSearchText(searchText: $0)
//            }
//                self.searchRepository.searchText.accept(value!)
//                print (self.searchRepository.searchText.value)
//                self.searchRepository.SearchState.accept(true)
//            }
//            else {
//                self.searchRepository.SearchState.accept(false)
//            }
//        }).disposed(by: disposeBag)
        
        
    }
    
    func prepareSearchText(searchText:String)->String {
        let textWithoutSpaces = searchText.removingSpaces
        return textWithoutSpaces.lowercased()
    }
    
    func prepareSearchList(searchList:[Photos]) {
        
        self.searchRepository.SearchState.asObservable().subscribe({
            state in
            if state.element == true {
                self.searchRepository.searchList.descriptions = self.fitchedData.value.map{
                $0.alt?.removingSpaces.lowercased() as! String
            }
            
                self.searchRepository.searchList.titles = self.fitchedData.value.map{
                $0.photographer?.removingSpaces.lowercased() as! String
            }
                
            }
            else {
               print ("No Searh requested")
            }
            
            
        })
       
        
    }
    
    
    func searchResult() {
        searchRepository.searchText.filter({$0.isEmpty}).subscribe { _ in
            self.searchRepository.requestedPictures.accept(self.fitchedData.value)
        }.disposed(by: disposeBag)

        searchRepository.searchText
            .filter({!$0.isEmpty})
            .map({ term in
                
                let result = self.fitchedData.value.filter({($0.photographer!.searchable().contains(term)) ||
                    (($0.alt!.searchable().contains(term)))
                })
                
                return result
            })
            .distinctUntilChanged()
            .bind(to: searchRepository.requestedPictures)
            .disposed(by: disposeBag)
        
//            .subscribe({ text in
//
//                let cellIndexofMatchingDescriptions = self.searchRepository.searchList.descriptions.compactMap({(item:String)->Int? in
//                    if (item.range(of: self.searchRepository.searchText.value, options: .caseInsensitive, range: nil, locale: nil) != nil) {
//                        return self.searchRepository.searchList.descriptions.firstIndex(of: item) }
//                else {
//                    return nil
//                }
//            }).removingDuplicates()
//
//                let cellIndexofMatchingTitles = self.searchRepository.searchList.titles.compactMap({(item:String)->Int? in
//                    if (item.range(of: self.searchRepository.searchText.value, options: .caseInsensitive, range: nil, locale: nil) != nil) {
//                        return self.searchRepository.searchList.titles.firstIndex(of: item) }
//                else {
//                    return nil
//                }
//                }).removingDuplicates()
//
//            let cellIndexOfSearchResult = (cellIndexofMatchingDescriptions + cellIndexofMatchingTitles).sorted()
//
//            var value:[Photos] = []
//            for numbers in cellIndexofMatchingTitles {
//                value.append(self.fitchedData.value[numbers])
//            }
//
//            self.searchRepository.requestedPictures.accept(value)
//
//        })
//        .disposed(by: disposeBag)
        
        }
    
}

extension String {
    func searchable() -> String {
        return self.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
