//
//  CollectionSentMemesViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit


class CollectionSentMemesViewController: UICollectionViewController {
    
    // MARK: Initializes local meme array, links to app delegate
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: View did load
    // pulls down memes stored in app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
        setDisplayFormat()
    }

    // MARK: View will appear
    // triggers refresh of local meme array
    
    override func viewWillAppear(_ animated: Bool) {
        updateCollection()
        setDisplayFormat()
    }
    
    // MARK: Updates Collection
    
    func updateCollection() {
        // Counts number of objects in master array (app delegate)
        let masterCount = appDelegate.memes.count
        // Counts number of objects in local array
        let localCount = (self.collectionView?.numberOfItems(inSection: 0))!
        // Counts discrepancy between local and master data objects
        var newItems = masterCount - localCount
        
        collectionView?.performBatchUpdates ({
            // Loops once for every new object required
            while newItems > 0    {
                // Reaches back for the first "new" object from master
                let newItem = appDelegate.memes[masterCount - newItems]
                // Appends that item into local storage
                memes.append(newItem)
                // Finds where a new row would go
                let index = IndexPath(row: (memes.count - 1), section: 0)
                // Inserts the item into that new row
                collectionView?.insertItems(at: [index])
                // Counts down the number of new objects needed
                newItems -= 1
            }
        }, completion: nil)
        setDisplayFormat()

    }
    
    // MARK: CollectionView
    // Number of items in collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    // MARK: Cell for item at
    // populates cells with local array data
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionSentMemeViewCell", for: indexPath) 
    
        let meme = memes[(indexPath as NSIndexPath).row]
        
        if let view = cell.viewWithTag(100) as? UIImageView {
            view.image = meme.memedImage
        }
        
        return cell
    }
    
    // MARK: Did select item at
    // Performs a segue with particular meme when a cell is selected
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeDetails", sender: AnyObject.self)
        let meme = memes[indexPath.row]
        print("sending meme that says \(meme.topText), \(meme.bottomText)")
    }

    // MARK: Prepare for segue
    // Packages up selected meme to pass along
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeDetails" {
            if let dest = segue.destination as? MemeDetailsViewController,
                let index = collectionView?.indexPathsForSelectedItems?.first {
                let meme = memes[index.row]
                print("SENDING MEME FROM COLLECTION WITH WORDS: \(meme.topText), \(meme.bottomText)")
                dest.meme = meme
            }
        }
    }
    
    // MARK: Set display format
    
    func setDisplayFormat () {
        let minimumInterItemSpacing: CGFloat = 5
        let minimumLineSpacing: CGFloat = 5
        let numberOfColumns: CGFloat = 3

        let width = ((collectionView?.frame.width)! - minimumInterItemSpacing - minimumLineSpacing) / numberOfColumns
        print("width = \(width)")
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = minimumInterItemSpacing
        layout.minimumLineSpacing = minimumLineSpacing

        layout.itemSize = CGSize(width: width, height: width)
        
    }
}
