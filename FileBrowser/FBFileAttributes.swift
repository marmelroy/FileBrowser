
import Foundation

public enum FBFileAttributes : Int
{
	case None = 0
	case FileName
	case FileSize
	case FileType
	case DateModified
	case DateCreated
	case DateAdded
	
	static public let numAttributes : Int = 7
	public func displayNameForAttribute()->String
	{
		switch self {
		case .FileName:
			return "Name"
		case .FileSize:
			return "Size"
		case .FileType:
			return "Type"
		case .DateModified:
			return "Date Modified"
		case .DateCreated:
			return "Date Created"
		case .DateAdded:
			return "Date Added"
		case .None:
			return "None"
		}
	}
}
