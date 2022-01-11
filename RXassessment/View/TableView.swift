//
//  ViewController.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 09/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

class TableView : UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let tableModel = TableViewModel()
    
    let disposalBag = DisposeBag()
    let throttleIntervalInMilliseconds = 100
    
    //MARK:- View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        tableModel.FitchData { tablePictures in
            if let pictures = tablePictures {
                DispatchQueue.main.async {
                    self.tableViewHandling ()
                }
            }
        }
    }
}

//MARK:- RX setup
private extension TableView {
    
    func setupSearchBar() {
        
        searchBar
            .rx
            .text
            .orEmpty
            .bind(to: tableModel.searchbar)
            .disposed(by: disposalBag)
        
    }
    
    func tableViewHandling() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableModel.fitchedData.map{$0}
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: TableViewCell.identifier,
                           cellType: TableViewCell.self)){
                row, pictures, cell in
                
                cell.configureTableCell(photos: pictures)
//                cell.layoutIfNeeded()
            }.disposed(by: disposalBag)
    }
}


