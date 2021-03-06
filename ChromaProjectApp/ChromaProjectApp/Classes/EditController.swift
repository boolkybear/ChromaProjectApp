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
		self.nameField?.text = self.documentViewModel?.name ?? ""
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
				let pathExtension = ChromaDocument.validExtensions().first ?? "chroma"
				let filePath = "\(localDocumentsPath)/\(randomName).\(pathExtension)"
				if let fileUrl = NSURL.fileURLWithPath(filePath)
				{
					let newDocument = ChromaDocument(fileURL: fileUrl)
					newDocument.saveToURL(fileUrl, forSaveOperation: UIDocumentSaveOperation.ForCreating) {
						success in
						
						if success
						{
							self.creationHandler?(newDocument)
							newDocument.setName(name)
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
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.documentViewModel?.count() ?? 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: UITableViewCell = {
			let visibleLayer = self.documentViewModel?[indexPath.row]
			if let layerType = visibleLayer?.type
			{
				let visibleCell: VisibilityCell? = {
					switch layerType
					{
					case .Caption:
						return tableView.dequeueReusableCellWithIdentifier("CaptionCell") as? VisibilityCaptionCell
						
					case .Chroma:
						return tableView.dequeueReusableCellWithIdentifier("ChromaCell") as? VisibilityLayerCell
					
					case .Background:
						return tableView.dequeueReusableCellWithIdentifier("BackgroundCell") as? VisibilityBackgroundCell
					}
				}()
				
				if let visibleCell = visibleCell
				{
					visibleCell.visibleLayer = visibleLayer
					return visibleCell
				}
			}
			
			return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DefaultCell")
		}()
		
		return cell
	}
}