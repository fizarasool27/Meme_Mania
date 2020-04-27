//
//  MemeDetailVC.swift
//  Meme Mania
//
//  Created by Fiza Rasool on 28/04/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    @IBOutlet weak var detailedMemeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
            
    }
    
}
