# FormWorkFlow

This is a Proof-of-Concept sample projet to suggest how to implement a workflow of generic forms using Promises.

Basically, the idea is to consider ViewControllers as functional boxes, taking inputs and returning a `Promise<T>` which will be fulfilled when the user has validated to screen.

Then we can easily create a flow of ViewControllers by using the promise's `then` block to tell which VC should appear next in the flow.

A simple, linear workflow could then look like this:

```swift
// The workflow of ViewControllers will be pushed in a
// NavCtrl presented in a modal
let nc = UINavigationController()
self.presentViewController(nc, animated: true, completion: nil)

// This is quite clear from this code layout how the screens flow
firstly {
  self.pushScreen1(nc)
}
.then {
  self.pushScreen2(nc)
}
.then {
  self.pushScreen3(nc)
}
.then {
  self.pushScreen4(nc)
}
.recover { (error: ErrorType) -> Void in
  try self.handleCancellation(error)
}
.recover { e in
  print("Wooops, something bad (other than a cancellation) happened: \(e)")
}
.always {
  self.dismissViewControllerAnimated(true, completion: nil)
  print(self.model)
}
```

Where the `pushScreenX(nc)` functions might look like this:

```swift
private func pushScreen1(nc: UINavigationController) -> Promise<Void> {
    // Create the screen/VC
    let form = FormViewController(…)
    // Push it
    nc.pushViewController(form, animated: false)
    // Return a promise of fulfillment
    // (which will be fired when the use validate the screen)
    return form.promise()
  }
```

See `FormViewController.swift`'s code to see how the promise is created. In this VC's code, a tap on the `rightBarButtonItem` fulfills it while a tap on the `leftBarButtonItem` rejects it.
