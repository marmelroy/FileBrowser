//
//  AlertUtilities.swift
//  FileBrowser
//
//

import Foundation

public class AlertUtilities
{
	static func Alert_AskForText( title: String, question: String, presenter: UIViewController, okHandler: ((UIAlertController) -> Swift.Void)? = nil, cancelHandler: ((UIAlertController) -> Swift.Void)? = nil )
		
	{
		let alertController = UIAlertController(title: title, message: question, preferredStyle: .alert)
		
		alertController.addTextField(configurationHandler: nil)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
			if let cancelHandler = cancelHandler
			{
				cancelHandler(alertController)
			}
		} )
		let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) in
			if let okHandler = okHandler
			{
				okHandler(alertController)
			}
		} )
		
		alertController.addAction(cancelAction)
		alertController.addAction(okAction)
		
		presenter.present(alertController, animated: true, completion: nil)
	}
	
	public static func Alert_Show(title: String, message: String, presenter: UIViewController? = nil )
	{
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil )
		
		alertController.addAction(cancelAction)
		
		if let presenter = presenter
		{
			presenter.present(alertController, animated: true, completion: nil)
		}
		else
		{
			alertController.show()
		}
	}
}

extension UIAlertController {
	
	func show() {
		present(animated: true, completion: nil)
	}
	
	func present(animated: Bool, completion: (() -> Void)?) {
		if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
			presentFromController(rootVC, animated: animated, completion: completion)
		}
	}
	
	private func presentFromController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?)
	{
		if let navVC = controller as? UINavigationController,
			let visibleVC = navVC.visibleViewController
		{
			presentFromController(visibleVC, animated: animated, completion: completion)
		}
		else
		{
			if let tabVC = controller as? UITabBarController,
				let selectedVC = tabVC.selectedViewController
			{
				presentFromController(selectedVC, animated: animated, completion: completion)
			}
			else
			{
				controller.present(self, animated: animated, completion: completion)
			}
		}
	}
}
