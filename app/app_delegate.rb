class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = UIViewController.alloc.init
    rootViewController.title = 'InAppPurchase Test'
    rootViewController.view.backgroundColor = UIColor.whiteColor
    purchase_view = PurchaseViewController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(purchase_view)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end
