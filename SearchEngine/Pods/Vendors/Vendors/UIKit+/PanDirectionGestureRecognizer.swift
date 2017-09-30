//
//  PanDirectionGestureRecognizer.swift
//  Pods
//
//  Created by away4m on 12/31/16.
//
//

//
//  PanDirectionGestureRecognizer+Extension.swift
//
//  Created by Augus on 8/23/15.
//  Copyright © 2015 iAugus. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public enum PanDirection {
  case left
  case leftEdge
  case right
  case rightEdge
  case up
  case down
  case vertical
  case horizontal
  case none
}

public class PanDirectionGestureRecognizer: UIPanGestureRecognizer {

  let direction: PanDirection

  init(direction: PanDirection, target: AnyObject, action: Selector) {
    self.direction = direction
    super.init(target: target, action: action)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)

    guard state == .began else { return }

    let velocity = self.velocity(in: view)
    let isHorizontal = fabs(velocity.x) > fabs(velocity.y)
    let isVertical = fabs(velocity.y) > fabs(velocity.x)

    switch direction {

    case .left where velocity.x > 0 || isVertical:
      state = .cancelled
    case .right where velocity.x < 0 || isVertical:
      state = .cancelled
    case .up where velocity.y > 0 || isHorizontal:
      state = .cancelled
    case .down where velocity.y < 0 || isHorizontal:
      state = .cancelled

    case .horizontal where isVertical:
      state = .cancelled
    case .vertical where isHorizontal:
      state = .cancelled

    default:
      break
    }
  }
}

public class UIPanGestureRecognizerWithDirection: UIPanGestureRecognizer {

  var direction: PanDirection

  override init(target: Any?, action: Selector?) {
    direction = .none
    super.init(target: target, action: action)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)

    guard state == .began else { return }

    let velocity = self.velocity(in: view)
    let isHorizontal = fabs(velocity.x) > fabs(velocity.y)

    if isHorizontal {
      if velocity.x > 0 {
        direction = .right
      } else {
        direction = .left
      }
    } else {
      if velocity.y > 0 {
        direction = .down
      } else {
        direction = .up
      }
    }
  }
}

public class UIPanGestureRecognizerWithEdgeDirection: UIPanGestureRecognizer {

  public var edgeOffset: CGFloat = 44.0

  var direction: PanDirection

  override init(target: Any?, action: Selector?) {
    direction = .none
    super.init(target: target, action: action)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)

    guard state == .began else { return }

    let velocity = self.velocity(in: view)
    let locationX = location(in: view).x
    let isHorizontal = fabs(velocity.x) > fabs(velocity.y)

    if isHorizontal {
      if velocity.x > 0 {
        if locationX < edgeOffset {
          direction = .leftEdge
        } else {
          direction = .right
        }
      } else {
        if locationX > UIScreen.main.width - edgeOffset {
          direction = .rightEdge
        } else {
          direction = .left
        }
      }
    } else {
      if velocity.y > 0 {
        direction = .down
      } else {
        direction = .up
      }
    }
  }
}
