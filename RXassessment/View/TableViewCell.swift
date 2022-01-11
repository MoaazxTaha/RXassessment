//
//  TableViewCell.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 09/01/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = String(describing: TableViewCell.self)

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    
    func configureTableCell (photos : Photos) {
        cellImage.sd_setImage(with: URL(string: photos.src!.small!)) {_,_,_,_ in
            self.cellTitle.text = photos.photographer
            self.cellDescription.text = photos.alt

            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }


    }
    
}
