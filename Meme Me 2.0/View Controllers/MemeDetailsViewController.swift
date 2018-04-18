//
//  MemeDetailsViewController.swift
//  Meme Me 2.0
//
//  Created by Erich Clark on 4/15/18.
//  Copyright © 2018 Erich Clark. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    var meme: Meme!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sentMemeDetailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sentMemeDetailImageView.image = meme.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
