import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController(rootViewController: MoviesViewController(pageType: .top))
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.barTintColor = .systemBackground
        navigationController.view.backgroundColor = .systemBackground
        navigationController.navigationItem.largeTitleDisplayMode = .always
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        MediaCache.clearCache()
    }
}
