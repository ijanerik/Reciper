//
//  simpleLoader.swift
//  Reciper
//
//  Created by Jan Erik van Woerden on 29-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class SimpleLoader {
    let main: UITableViewController
    var indicator: UIActivityIndicatorView!
    
    init(_ main: UITableViewController) {
        self.main = main
        initLoader()
    }
    
    func initLoader() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.main.view.center
        self.main.view.addSubview(indicator)
    }
    
    func start() {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
    }
    
    func stop() {
        self.indicator.stopAnimating()
        self.indicator.hidesWhenStopped = true
    }
}
