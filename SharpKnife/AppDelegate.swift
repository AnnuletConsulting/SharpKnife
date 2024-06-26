import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()

        let logVC = UINavigationController(rootViewController: LogViewController())
        let knivesVC = UINavigationController(rootViewController: KnivesViewController())
        let sharpenersVC = UINavigationController(rootViewController: SharpenersViewController())

        logVC.tabBarItem = UITabBarItem(title: "Log", image: UIImage(systemName: "list.bullet"), tag: 0)
        knivesVC.tabBarItem = UITabBarItem(title: "Knives", image: UIImage(systemName: "scissors"), tag: 1)
        sharpenersVC.tabBarItem = UITabBarItem(title: "Sharpeners", image: UIImage(systemName: "wrench"), tag: 2)

        tabBarController.viewControllers = [logVC, knivesVC, sharpenersVC]
        tabBarController.selectedIndex = 0

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}
