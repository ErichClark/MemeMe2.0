//
//  MemeDetailsViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/15/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    // MARK: makes a local copy of a passed-in meme
    var meme: Meme!
    
    @IBOutlet weak var sentMemeDetailImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sentMemeDetailImageView.image = meme.memedImage
    }
}
