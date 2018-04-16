//
//  CollectionSentMemesViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/14/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit


class CollectionSentMemesViewController: UICollectionViewController {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("loaded memes from AppDelegate with \(appDelegate.memes) memes.")
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (collectionView?.frame.width)! / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("MEMES.COUNT = \(memes.count)")
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

}
