//
//  DocumentsController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

class DocumentsController: UITableViewController {

	private enum Sections: Int
	{
		case AddDocument = 0
		case Document
		case Count
	}
	
	private enum Segues: String
	{
		case EditControllerPush = "editPushSegue"
	}
	
	var documentManager: DocumentManager? = nil
	
	required init(coder aDecoder: NSCoder) {
		self.documentManager = DocumentManager()
		
		self.documentManager?.path = DocumentManager.localDocumentsPath()
		
		super.init(coder: aDecoder)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Sections.Count.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rowCount: Int = {
			switch Sections(rawValue: section)!
			{
			case .AddDocument:
				return 1
				
			case .Document:
				return self.documentManager?.count() ?? 0
				
			case .Count:
				return 0
			}
		}()
		
		return rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifierInSection(indexPath.section), forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
		if indexPath.section == Sections.Document.rawValue
		{
			if let document = self.documentManager?[indexPath.row]
			{
				if let documentCell = cell as? DocumentCell
				{
					documentCell.document = document
				}
			}
		}

        return cell
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let height: CGFloat = {
			switch Sections(rawValue: indexPath.section)!
			{
			case .AddDocument:
				return 44.0
				
			case .Document:
				return 100.0
				
			case .Count:
				return 0
			}
		}()
		
		return height
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		switch Sections(rawValue: indexPath.section)!
		{
		case .AddDocument:
			self.performSegueWithIdentifier(Segues.EditControllerPush.rawValue, sender: nil)
			break
			
		case .Document:
			let document = self.documentManager?[indexPath.row]
			self.performSegueWithIdentifier(Segues.EditControllerPush.rawValue, sender: document)
			break
			
		case .Count:
			break
		}
	}

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return indexPath.section == Sections.Document.rawValue
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
			self.documentManager?.deleteDocumentAtIndex(indexPath.row)
			
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
		
		if let identifier = segue.identifier
		{
			if let segueIdentifier = Segues(rawValue: identifier)
			{
				switch segueIdentifier
				{
				case .EditControllerPush:
					if let controller = segue.destinationViewController as? EditController
					{
						let document = sender as? ChromaDocument
						var handler: CreationHandler? = nil
						if let document = document
						{
							controller.setDocument(document, onCreate: nil)
						}
						else
						{
							controller.setDocument(nil) {
								newDocument in
								
								let doc: ChromaDocument = newDocument
								self.documentManager?.appendDocument(doc)
							}
						}
					}
				}
			}
		}
    }
}

private extension DocumentsController
{
	func cellIdentifierInSection(section: Int) -> String
	{
		let identifier: String = {
			switch Sections(rawValue: section)!
			{
			case .AddDocument:
				return "addDocumentCell"
				
			case .Document:
				return "documentCell"
				
			case .Count:
				return ""
			}
		}()
		
		return identifier
	}
}
