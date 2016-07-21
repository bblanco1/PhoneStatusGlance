//
//  MasterViewController.swift
//  GroupFileViewer
//
//  Created by Thomas Elliott on 7/23/16.
//  Copyright © 2016 Tom Elliott. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()

    var directoryURL: NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        // Try getting the watch logs:
        if let _ = directoryURL {
        } else {
            if let container =      NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.phonestatusglance.telliott.io") {
                directoryURL = container
            }
        }
        
        if let container = directoryURL {
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(container, includingPropertiesForKeys: nil, options: [])
                objects = directoryContents
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            self.title = container.lastPathComponent
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSURL
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        if segue.identifier == "showFolder" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSURL
                let controller = segue.destinationViewController as! MasterViewController
                controller.directoryURL = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let object = objects[indexPath.row] as! NSURL
        
        var identifier = "FileCell"
        
        var isDirectory: ObjCBool = ObjCBool(false)
        if NSFileManager.defaultManager().fileExistsAtPath(object.path!, isDirectory: &isDirectory) {
            if isDirectory {
                identifier = "FolderCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel!.text = object.lastPathComponent
        return cell
    }

}

