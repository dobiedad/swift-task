import Foundation
import CoreData


extension Message {
    private func convertJSONStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func initWithNotificationData(data: AnyObject) {
        var result = [String: AnyObject]()
        if data is String{
            result = convertJSONStringToDictionary(text: data as! String)!
        }
        else{
            result = (data as AnyObject) as! [String : AnyObject]
        }
        
        self.senderName = result["sendername"] as! String?
        self.id = result["id"] as! Int32
        self.message = result["message"] as! String?
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var senderName: String?
    @NSManaged public var id: Int32
    @NSManaged public var message: String?

}
