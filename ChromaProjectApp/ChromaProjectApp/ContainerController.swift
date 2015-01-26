//
//  ContainerController.swift
//  ChromaProjectApp
//
//  Created by Boolky Bear on 25/12/14.
//  Copyright (c) 2014 ByBDesigns. All rights reserved.
//

import UIKit

private enum Segue: String
{
	case DocumentEmbedSegue = "documentEmbedSegue"
	case SettingsEmbedSegue = "settingsEmbedSegue"
}

class ContainerController: UIViewController {

	@IBOutlet var settingsContainer: UIView!
	@IBOutlet var settingsButton: UIBarButtonItem!
	
	var iCloudManager: ICloudManager? = nil
	
	var documentSelectionController: DocumentSelectionController? = nil
	var settingsController: SettingsController? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.iCloudManager = ICloudManager() {
			ubiquityToken in
			
			let saveSettings = NSUserDefaults.saveSettings()
			
			if saveSettings == .SaveInCloud
			{
				let currentToken: AnyObject? = NSUserDefaults.ubiquityToken()
				switch (currentToken, ubiquityToken)
				{
				case (nil, nil):
					break
					
				case (nil, .Some):
					let unwrappedUbiquityToken = ubiquityToken! as protocol<NSCoding, NSCopying, NSObjectProtocol>
					NSUserDefaults.setUbiquityToken(unwrappedUbiquityToken)
					self.documentSelectionController?.reloadDocuments(saveSettings)
					
				case (.Some, nil):
					NSUserDefaults.setUbiquityToken(nil)
					self.settingsContainer.hidden = false
					self.settingsController?.enableiCloud(false)
					let alertController = UIAlertController(title: NSLocalizedString("No iCloud", comment: ""),
						message: NSLocalizedString("Connect to iCloud again to keep saving in iCloud", comment: ""),
						preferredStyle: .Alert)
					let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Cancel) { action in }
					alertController.addAction(action)
					self.presentViewController(alertController, animated: true, completion: nil)
					
				case (.Some, .Some):
					let unwrappedCurrentToken: AnyObject = currentToken!
					let unwrappedUbiquityToken: AnyObject = ubiquityToken!
					if unwrappedCurrentToken.isEqual(unwrappedUbiquityToken) == false
					{
						self.settingsContainer.hidden = false
						self.settingsController?.enableiCloud(true)
						let alertController = UIAlertController(title: NSLocalizedString("iCloud account changed", comment: ""),
							message: NSLocalizedString("Changing iCloud account will reload your documents, please confirm", comment: ""),
							preferredStyle: .Alert)
						let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Destructive) { action in }
						alertController.addAction(action)
						self.presentViewController(alertController, animated: true, completion: nil)
					}
					
				default:
					break
				}
			}
			else if saveSettings == .NotConfigured
			{
				self.settingsContainer.hidden = false
				self.settingsController?.enableiCloud(ubiquityToken != nil)
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		switch(segue.identifier!)
		{
		case Segue.DocumentEmbedSegue.rawValue:
			self.documentSelectionController = segue.destinationViewController as? DocumentSelectionController
			self.setupControllers(self.settingsController, selectionController: self.documentSelectionController)
			
		case Segue.SettingsEmbedSegue.rawValue:
			self.settingsController = segue.destinationViewController as? SettingsController
			let iCloudToken = NSFileManager.defaultManager().ubiquityIdentityToken
			self.settingsController?.enableiCloud(iCloudToken != nil)
			self.setupControllers(self.settingsController, selectionController: self.documentSelectionController)
			
		default:
			break
		}
    }
}

// MARK: - Actions
extension ContainerController
{
	@IBAction func settingsButtonClicked(sender: UIBarButtonItem) {
		self.settingsContainer.hidden = (self.settingsContainer.hidden == false)
	}
	
	@IBAction func addDocumentButtonClicked(sender: UIBarButtonItem) {
		self.documentSelectionController?.addNewDocument()
	}
}

private extension ContainerController
{
	func setupControllers(settingsController: SettingsController?, selectionController: DocumentSelectionController?)
	{
		ifNotNil(selectionController, settingsController) {
			selectionController, settingsController in
			
			settingsController.settingsChange = {
				settings in
				
				selectionController.reloadDocuments(settings)
				
				UIView.animateWithDuration(0.3, animations: {
					self.settingsContainer.alpha = 0.0 }) {
						isFinished in
						
						self.settingsContainer.hidden = true
						self.settingsContainer.alpha = 1.0
				}
			}
		}
	}
}