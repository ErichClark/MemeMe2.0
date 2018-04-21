//
//  TableSentMemesViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit

class TableSentMemesViewController: UITableViewController {
    
    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
    }

    override func viewWillAppear(_ animated: Bool) {
        updateTable()
    }
    
    func updateTable() {
        let masterCount = appDelegate.memes.count
        let tableCount = self.tableView.numberOfRows(inSection: 0)
        var newItems = masterCount - tableCount
        print("NEW ITEMS FOUND = \(newItems)")
        
        tableView.performBatchUpdates({
            while newItems > 0   {
                let newItem = appDelegate.memes[masterCount - newItems]
                memes.append(newItem)
                let index = IndexPath(row: (memes.count - 1), section: 0)
                tableView.insertRows(at: [index], with: UITableViewRowAnimation.automatic)
                print("***TABLE ITEM WITH TOP TEXT: **\(newItem.topText)** IS COMPLETE **")
                newItems -= 1
            }
        }, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableSentMemeCell", for: indexPath)

        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        if let memedImage = meme.memedImage {
            cell.imageView?.image = memedImage
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeDetails", sender: AnyObject.self)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeDetails" {
            if let dest = segue.destination as? MemeDetailsViewController,
                let index = tableView.indexPathsForSelectedRows?.first {
                let meme = memes[index.row]
                print("SENDING MEME FROM TABLE WITH WORDS: \(meme.topText), \(meme.bottomText)")
                dest.meme = meme
            }
        }
    }
    

}
