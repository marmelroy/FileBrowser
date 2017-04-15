//
//  FileActivityViewController.swift
//  FileBrowser
//
//

import Foundation


class FileActivityViewController
{

	static func activityControllerFor( file: FBFile, title: String, sender:UIBarButtonItem ) -> UIActivityViewController
	{
		let items = [file as Any, file.fileLocation as Any] as [Any]
		
		let activities = [FileMoveActivity()]
				
		let controller = UIActivityViewController( activityItems:items, applicationActivities: activities )
		
		controller.setValue( file.displayName, forKey: "subject")
		
		if UIDevice.current.userInterfaceIdiom == .pad
		{
			controller.popoverPresentationController?.barButtonItem = sender;
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
