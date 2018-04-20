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
        
        let width = (collectionView?.frame.width)! / 2
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }

    override func viewWillAppear(_ animated: Bool) {
        memes = appDelegate.memes
        updateCollection()
    }
    
    func updateCollection() {
        let expectedItemCount = appDelegate.memes.count
        let updatesInLoop = expectedItemCount - (self.collectionView?.numberOfItems(inSection: 0))!
        var loopChecker = 0
        
        collectionView?.performBatchUpdates ({
            for _ in 0..<updatesInLoop    {
                let index = IndexPath(row: (expectedItemCount - 1), section: 0)
                collectionView?.insertItems(at: [index])
                loopChecker += 1
                print("COLLECTION UPDATE loop #\(loopChecker)")
            }
        }, completion: nil)
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
}
