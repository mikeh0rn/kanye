//
//  ViewController.swift
//  KanyeQuotes
//
//  Created by Michael Horn on 5/10/19.
//  Copyright © 2019 Mike Horn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var kanyeQuoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUpKanyeQuote()
        
        // Do any additional setup after loading the view.
    }
    
    
    var headers: HTTPHeaders {
        get {
            return [
                "Accept": "application/json"
            ]
        }
    }
    
    func loadUpKanyeQuote() {
        let url = "https://api.kanye.rest"
        var kanyeQuote = ""
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let data: Data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    kanyeQuote = json["quote"].stringValue
                    self.kanyeQuoteLabel.text = kanyeQuote
                }
        }
    }
    
    @IBAction func changeKanyeQuote(sender: UIButton) {
        loadUpKanyeQuote()
    }
    
}

