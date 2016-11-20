import UIKit
import CoreData
import Firebase
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate {

    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {

        let message:Message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: CoredataController.persistentContainer.viewContext) as! Message
        let data:AnyObject = remoteMessage.appData["jsondata"] as AnyObject

        message.initWithNotificationData(data:data)
        CoredataController.saveContext()

    }


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        registerForPushNotifications(application: application)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let mainView = MessageTableViewController()
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""

        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        #if DEBUG
            FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        #else
            FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        #endif

        print("Device Token = ", token)


    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0;
        connectToFcm()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoredataController.saveContext()
    }

    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }

        connectToFcm()
    }

    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        saveNotification(notification: notification)
    }

    func saveNotification(notification: UNNotification){
        let message:Message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: CoredataController.persistentContainer.viewContext) as! Message
        message.initWithNotificationData(data:notification.request.content.userInfo["jsondata"] as AnyObject)
        CoredataController.saveContext()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        saveNotification(notification: response.notification)
    }

    func registerForPushNotifications(application: UIApplication) {
        NotificationCenter.default.addObserver(self,
                                                     selector: #selector(tokenRefreshNotification(_:)),
                                                     name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                     object: nil)
        UNUserNotificationCenter.current().delegate = self
        FIRMessaging.messaging().remoteMessageDelegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
            if (granted)
            {
                application.registerForRemoteNotifications()
            }
        })

    }

}
