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
    
    let viewModel = TableViewModel()
    
    let disposalBag = DisposeBag()
    let debounceIntervalInMilliseconds = 500
    
    //MARK:- View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchData()
        tableViewSetup()
        bind()
    }
}

//MARK:- RX setup
private extension TableView {
    
    func bind() {
        
        //Filteration
        searchBar.rx.text
        .orEmpty
        .observe(on: MainScheduler.asyncInstance)
        .distinctUntilChanged()
        .debounce(.milliseconds(debounceIntervalInMilliseconds), scheduler: MainScheduler.instance)
        .map({ term in
                term.lowercased()
                    .trimmingCharacters(in: .whitespaces)
            })
        .subscribe(onNext: { searchtext in
                self.viewModel.searchText.accept(searchtext)
        })
        .disposed(by: disposalBag)
        
        //TableView dataSource
        viewModel.filteredPictures
//            .map{$0}
            .subscribe(on: MainScheduler.instance)
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: TableViewCell.identifier,
                           cellType: TableViewCell.self)){
                row, pictures, cell in
                
                
                cell.configureTableCell(photos: pictures)
            }.disposed(by: disposalBag)
        
    }
    
    func tableViewSetup() {

        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
    }
    
//    func tableViewHandling() {
//
//
//    }
}


