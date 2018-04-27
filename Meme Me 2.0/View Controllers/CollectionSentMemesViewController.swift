//
//  CollectionSentMemesViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit


class CollectionSentMemesViewController: UICollectionViewController {
    
    var memes = [Meme]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memes = appDelegate.memes
        setDisplayFormat()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateCollection()
        setDisplayFormat()
    }
    
    func updateCollection() {
        let masterCount = appDelegate.memes.count
        let localCount = (self.collectionView?.numberOfItems(inSection: 0))!
        var newItems = masterCount - localCount
        print("NEW ITEMS FOUND = \(newItems)")
        
        collectionView?.performBatchUpdates ({
            while newItems > 0    {
                let newItem = appDelegate.memes[masterCount - newItems]
                memes.append(newItem)
                let index = IndexPath(row: (memes.count - 1), section: 0)
                collectionView?.insertItems(at: [index])
                print("***COLLECTION ITEM WITH TOP TEXT: **\(newItem.topText)** IS COMPLETE **")
                newItems -= 1
            }
        }, completion: nil)
        setDisplayFormat()

    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionSentMemeViewCell", for: indexPath) 
    
        let meme = memes[(indexPath as NSIndexPath).row]
        
        if let view = cell.viewWithTag(100) as? UIImageView {
            view.image = meme.memedImage
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeDetails", sender: AnyObject.self)
        let meme = memes[indexPath.row]
        print("sending meme that says \(meme.topText), \(meme.bottomText)")
    }

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
