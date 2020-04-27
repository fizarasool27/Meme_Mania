//
//  SentMemesTableViewController.swift
//  Meme Mania
//
//  Created by Fiza Rasool on 27/04/20.
//  Copyright © 2020 Fiza Rasool. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SentMemesTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMemesTableViewCell")
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell") as! SentMemesTableViewCell
        let memeRow = memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = memeRow.memedImage
        cell.topText.text = memeRow.topText
        cell.bottomText.text = memeRow.bottomText
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        
        detailController.detailedMemeImageView.image = memes[(indexPath as NSIndexPath).row].memedImage
        
        navigationController!.pushViewController(detailController, animated: true)
    }



}
