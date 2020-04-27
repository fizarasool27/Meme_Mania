//
//  SentMemesTableViewCell.swift
//  Meme Mania
//
//  Created by Fiza Rasool on 27/04/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var topText: UILabel!
    
    @IBOutlet weak var bottomText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
