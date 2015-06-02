//
//  ApiBookTableViewCell.swift
//  ProjetoLivro
//
//  Created by Bruno Pereira dos Santos on 6/2/15.
//  Copyright (c) 2015 ABCD. All rights reserved.
//

import UIKit

class ApiBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookInformation: UILabel!
    @IBOutlet weak var bookPublish: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
