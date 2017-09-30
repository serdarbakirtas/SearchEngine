open class TutorialScrollViewController: UIPageViewController {
  open var storyboardName: String { return "Main" }
  fileprivate(set) lazy var orderedViewControllers: [UIViewController] = []
  
  open var pageControl = UIPageControl()
  
  // Controllable variable for users. An array which contains all the storyboard ids
  // of the viewControllers to be rendered
  open var controllerStoryboardIds: [String] = [] {
    didSet {
      newColoredViewController(controllerStoryboardIds)
      // class method by pageViewController: set up the viewControllers we wanna page through
      if let firstViewController = orderedViewControllers.first {
        setViewControllers([firstViewController],
                           direction: .forward,
                           animated: false,
                           completion: nil)
      }
      
      pageControl.numberOfPages = orderedViewControllers.count
    }
  }
  
  // whether pageLooping is available
  open var enablePageLooping: Bool = false
  
  open var currentPage = 0 {
    didSet {
      pageControl.currentPage = currentPage
      setViewControllers([orderedViewControllers[currentPage]], direction: .forward, animated: false, completion: nil)
    }
  }
  
  open var pageControlIsHidden = false {
    didSet {
      pageControl.isHidden = pageControlIsHidden
    }
  }
  
  open var pageControlXPosition: CGFloat? {
    didSet {
      pageControl.frame = CGRect(x: pageControlXPosition!, y: pageControl.frame.origin.y, width: pageControl.frame.width, height: pageControl.frame.height)
    }
  }
  
  open var pageControlYPosition: CGFloat? {
    didSet {
      pageControl.frame = CGRect(x: pageControl.frame.origin.x, y: pageControlYPosition!, width: pageControl.frame.width, height: pageControl.frame.height)
    }
  }
  
  open var enableTappingPageControl: Bool = true
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    delegate = self
    
    let pageControlHeight: CGFloat = 50
    pageControl.frame = CGRect(x: 80, y: view.frame.height - pageControlHeight, width: view.frame.width - 160, height: pageControlHeight)
    
    pageControl.numberOfPages = orderedViewControllers.count
    pageControl.currentPage = currentPage
    pageControl.addTarget(self, action: #selector(TutorialScrollViewController.didTapPageControl(_:)), for: .touchUpInside)
    
    view.addSubview(pageControl)
    
  }
  
  open override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // Bring the pageControl to front so that its background color is transparent
    for subView in view.subviews {
      if subView is UIScrollView {
        subView.frame = view.bounds
      } else if subView is UIPageControl {
        view.bringSubview(toFront: subView)
      }
    }
  }
  
  // MARK: - Helper Methods:
  fileprivate func newColoredViewController(_ ViewControllerNames: [String]) -> [UIViewController] {
    
    for viewControllerStoryBoardId in ViewControllerNames {
      
      orderedViewControllers.append(UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: "\(viewControllerStoryBoardId)"))
    }
    
    return orderedViewControllers
  }
  
  open func goNext() {
    if let currentViewController = viewControllers?[0] {
      let currentPageIndex = orderedViewControllers.index(of: currentViewController)! + 1
      
      if currentPageIndex < pageControl.numberOfPages {
        setViewControllers([orderedViewControllers[currentPageIndex]], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = currentPageIndex
      }
    }
  }
  
  open func didTapPageControl(_ pageControl: UIPageControl?) {
    
    if !enableTappingPageControl {
      return
    }
    
    if let pageControl = pageControl {
      
      if let currentViewController = viewControllers?[0] {
        let currentPageIndex = orderedViewControllers.index(of: currentViewController)
        var upcomingTutorialPage = pageControl.currentPage
        
        var direction: UIPageViewControllerNavigationDirection = (currentPageIndex! <= upcomingTutorialPage) ? .forward : .reverse
        
        if currentPageIndex == 0 && currentPageIndex == upcomingTutorialPage {
          direction = .reverse
        }
        
        if enablePageLooping {
          
          switch currentViewController {
          case orderedViewControllers.last!:
            if direction == .forward {
              pageControl.currentPage = 0
              upcomingTutorialPage = 0
            }
          case orderedViewControllers.first!:
            if direction == .reverse {
              pageControl.currentPage = orderedViewControllers.count - 1
              upcomingTutorialPage = orderedViewControllers.count - 1
            }
          default:
            break
          }
        }
        
        setViewControllers([orderedViewControllers[upcomingTutorialPage]], direction: direction, animated: true, completion: nil)
      }
    }
  }
}

// MARK: UIPageViewControllerDataSource

extension TutorialScrollViewController: UIPageViewControllerDataSource {
  
  // protocal function: render previous page
  public func pageViewController(_: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    guard previousIndex >= 0 else {
      if enablePageLooping {
        
        return orderedViewControllers.last
        
      } else {
        return nil
      }
    }
    
    guard orderedViewControllers.count > previousIndex else {
      return nil
    }
    
    return orderedViewControllers[previousIndex]
  }
  
  // protocal function: render later page
  public func pageViewController(_: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = orderedViewControllers.count
    
    guard orderedViewControllersCount != nextIndex else {
      
      if enablePageLooping {
        
        return orderedViewControllers.first
        
      } else {
        return nil
      }
      
    }
    
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    
    return orderedViewControllers[nextIndex]
    
  }
  
  //    // protocal function: render page control
  //    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
  //        return orderedViewControllers.count
  //    }
  //
  //    // protocal function: determine the current page
  //    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
  //        guard let currentViewController = viewControllers?.first,
  //            currentViewControllerIndex = orderedViewControllers.indexOf(currentViewController) else {
  //                return 0
  //        }
  //
  //        return currentViewControllerIndex
  //    }
}

extension TutorialScrollViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
    
    if completed {
      
      guard let currentViewController = pageViewController.viewControllers?[0],
        let currentViewControllerIndex = orderedViewControllers.index(of: currentViewController) else {
        fatalError("No controller to be rendered")
      }
      pageControl.currentPage = currentViewControllerIndex
    }
  }
}
