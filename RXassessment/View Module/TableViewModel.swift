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
    var searchbar : BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
}
     //MARK: - URL Session
    
extension TableViewModel {
        
    func FitchData (handler: @escaping (_ LoadedData: DataFromAPI?)->Void)  {
        let url = URL(string: url)
        
        let session = URLSession(configuration: .default)
        
        var Request = URLRequest.init(url: url!)
        Request.addValue(auth, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: Request) {
            (Data, URLResponse, Error) in
            
            if Error != nil {
                print(Error?.localizedDescription)  }
            
            if let data = Data {
                
                let decoded = self.decodeData(Data: data)
                if let data = decoded {
                    self.fitchedData.accept(data.photos!)
                        handler(data)  }
                    else {
                    handler(nil)
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
   


