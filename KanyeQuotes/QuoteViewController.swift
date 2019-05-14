//
//  QuoteViewController.swift
//  KanyeQuotes
//
//  Created by Michael Horn on 5/14/19.
//  Copyright © 2019 Mike Horn. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {

    var quote = ""
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteLabel.text = quote

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
