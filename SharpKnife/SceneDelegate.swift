import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
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
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
