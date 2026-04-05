---
name: custom-container-view-controller
description: Build UIKit custom container view controllers with correct child lifecycle management. Use when creating container view controllers, embedding child VCs, or managing view controller containment.
---

# Custom Container View Controller

## For non-lazy single child containers (the default)

- Add child view controllers in `init` (do NOT load the view in init).
- Add the child view controllers' view in `viewDidLoad`. Set the frame before adding the subview to self.view.
- Override `viewWillLayoutSubviews` and set the child view controller's view.frame to self.view.bounds.

## For lazy single child containers (special case)

Lazily loading / containers are rare, but sometimes are needed, eg if we need the entire view controller and view hierarchy set up before we can create a child. `BRootViewController` is an example of this. In these cases:

- Add a `setUpIfNeeded` method.
- It should run once, from within `viewIsAppearing`.
- It should create the child view controller (based on a provider closure) and insert it into the view controller hierarchy, and THEN the view hierarchy.
- Override `viewWillLayoutSubviews` and set the child view controller's view.frame to self.view.bounds.