//
//  EditController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 26/1/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit

typealias CreationHandler = (ChromaDocument)->Void

class EditController: UIViewController {

	@IBOutlet var previewImageView: UIImageView?
	@IBOutlet var tableView: UITableView?
	@IBOutlet var nameField: UITextField?
	
	var document: ChromaDocument?
	var creationHandler: CreationHandler?
	
	var documentViewModel: DocumentViewModel?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func setDocument(document: ChromaDocument?, onCreate: CreationHandler?)
	{
		self.document = document
		
		if self.document == nil
		{
			self.creationHandler = onCreate
		}
		
		self.documentViewModel = DocumentViewModel()
		self.documentViewModel?.document = self.document
		
		self.tableView?.reloadData()
	}
}

extension EditController: UITextFieldDelegate
{
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if let name = nameField?.text
		{
			if let document = self.document
			{
				document.setName(name)
				
				self.creationHandler?(document)
			}
			else
			{
				let localDocumentsPath = NSFileManager.localDocumentsPath()
				let randomName = NSUUID().UUIDString
				let filePath = "\(localDocumentsPath)/\(randomName)"
				if let fileUrl = NSURL.fileURLWithPath(filePath)
				{
					let newDocument = ChromaDocument(fileURL: fileUrl)
					newDocument.saveToURL(fileUrl, forSaveOperation: UIDocumentSaveOperation.ForCreating) {
						success in
						
						if success
						{
							self.creationHandler?(newDocument)
						}
					}
				}
			}
		}
		
		return true
	}
}

extension EditController: UITableViewDataSource, UITableViewDelegate
{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.documentViewModel?.co
	}
}