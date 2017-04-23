//
//  FileActivityViewController.swift
//  FileBrowser
//
//

import Foundation


class FileActivityViewController
{

	static func activityControllerFor( files: [FBFile], state: FileBrowserState, title: String, sender:UIBarButtonItem ) -> UIActivityViewController
	{
		var items = [Any]()
		
		for file in files
		{
			items.append(file)
			items.append(file.fileLocation as Any)
		}
		
		let activities = [FileMoveActivity( state: state )]
				
		let controller = UIActivityViewController( activityItems:items, applicationActivities: activities )
		
		//controller.setValue( file.displayName, forKey: "subject")
		
		if let popoverPresentationController = controller.popoverPresentationController
		{
			popoverPresentationController.barButtonItem = sender;
		}

		return controller
	}

}

//- (void)presentActivityControllerWithItem:(id)item andTitle:(NSString *)title sender:(id)sender
//{
//	if (!item) {
//		return;
//	}
//	
//	UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[item, title, self.webView] applicationActivities:[self applicationActivitiesForItem:item]];
//	controller.excludedActivityTypes = [self excludedActivityTypesForItem:item];
//	
//	if (title) {
//		[controller setValue:title forKey:@"subject"];
//	}
//	
//	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//		controller.popoverPresentationController.barButtonItem = sender;
//	}
//	
//	[self presentViewController:controller animated:YES completion:NULL];
//}
//
//}
