//
//  DeclarativeContainerViewController
//  fotobaski
//
//  Created by ALI KIRAN on 2/13/16.
//  Copyright © 2016 ALI KIRAN. All rights reserved.
//

import Foundation

class PlusContainerViewController: UIViewController {
    var segues: [String]?
    var segueControllerMap = NSMapTable<NSString, AnyObject>(keyOptions: NSPointerFunctions.Options(), valueOptions: NSPointerFunctions.Options.weakMemory)

    var currentSegueId: String!
    var currentController: UIViewController! {
        return segueControllerMap.object(forKey: currentSegueId as NSString) as! UIViewController
    }

    override func awakeFromNib() {
        self.segues = self.value(forKeyPath: "storyboardSegueTemplates.identifier") as? [String]

        guard segues != nil else {
            return
        }
        self.segueToIndex(1)
    }

    func segueToIndex(_ i: Int) {
        self.performSegue(withIdentifier: self.segues![i], sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let segueId = segue.identifier, segueId != currentSegueId else {
            return
        }

        let destinationController = segue.destination
        self.segueControllerMap.setObject(destinationController, forKey: segueId as NSString)

        if currentSegueId != nil {
            if let previousController: UIViewController = segueControllerMap.object(forKey: currentSegueId as NSString) as? UIViewController {
                previousController.willMove(toParentViewController: nil)
                previousController.view.removeFromSuperview()
                previousController.removeFromParentViewController()
            }
        }

        self.addChildViewController(destinationController)
        self.view.addSubview(destinationController.view)
        destinationController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": destinationController.view]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": destinationController.view]))

        destinationController.didMove(toParentViewController: self)

        self.currentSegueId = segueId
    }
}
