//
//  TableSentMemesViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit

class TableSentMemesViewController: UITableViewController {
    
    // MARK: Initializes local meme array, links to app delegate

    var memes: [Meme]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: View did load
    // pulls down memes stored in app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
    }

    // MARK: View will appear
    // triggers refresh of local meme array
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
        setDisplayFormat()
    }
    
    // MARK: Updates table
    
    func updateTable() {
        // Counts number of objects in master array (app delegate)
        let masterCount = appDelegate.memes.count
        // Counts number of objects in local array
        let tableCount = self.tableView.numberOfRows(inSection: 0)
        // Counts discrepancy between local and master data objects
        var newItems = masterCount - tableCount
        
        tableView.performBatchUpdates({
            // Loops once for every new object required
            while newItems > 0   {
                // Reaches back for the first "new" object from master
                let newItem = appDelegate.memes[masterCount - newItems]
                // Appends that item into local storage
                memes.append(newItem)
                // Finds where a new row would go
                let index = IndexPath(row: (memes.count - 1), section: 0)
                // Inserts the item into that new row
                tableView.insertRows(at: [index], with: UITableViewRowAnimation.automatic)
                // Counts down the number of new objects needed
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

    // MARK: cell for row at
    // populates table rows with local array data
    
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

    // MARK: Did select row at
    // Performs a segue with particular meme when a row is selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeDetails", sender: AnyObject.self)
    }

    // MARK: Prepare for segue
    // Packages up selected meme to pass along
    
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
    
    // MARK: Set display format

    func setDisplayFormat() {
        let height = (tableView.frame.height)
        let width = (tableView.frame.width)
        let rowsInPortraitMode: CGFloat = 5.2
        let rowsInLandscapeMode: CGFloat = 2.5
        
        if height > width {
            tableView.rowHeight = height / rowsInPortraitMode
        } else {
            tableView.rowHeight = height / rowsInLandscapeMode
        }
    }

}
