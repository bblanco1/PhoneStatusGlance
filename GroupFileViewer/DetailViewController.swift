//
//  DetailViewController.swift
//  GroupFileViewer
//
//  Created by Thomas Elliott on 7/23/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var fileContent: UITextView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem as? NSURL {
            self.title = detail.lastPathComponent
            do {
                let logContent = try NSString(contentsOfURL: detail, encoding: NSUTF8StringEncoding) as String
                if let fc = fileContent {
                    fc.text = logContent
                }
            } catch {
                if let fc = fileContent {
                    fc.text = "Error:\n\(error)"
                }
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

