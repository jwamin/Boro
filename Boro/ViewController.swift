//
//  ViewController.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var locationHandler:Locator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHandler = Locator()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

