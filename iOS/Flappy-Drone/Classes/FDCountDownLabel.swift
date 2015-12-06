import UIKit


class FDCountDownLabel: UILabel {


    var completionHandler = {}


    func countDown(count count: Int) {
        if count <= 0 {
            self.go()
            return
        }

        self.text = "\(count)"
        self.rotate(count: count)
    }

    private func rotate(count count: Int) {
        self.alpha = 0.0
        UIView.animateWithDuration(
            0.6,
            delay: 0.0,
            options: .CurveLinear,
            animations: { [unowned self] in
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            },
            completion: { [unowned self] finished in
                self.alpha = 1.0

                UIView.animateWithDuration(
                    0.14,
                    delay: 0.0,
                    options: .CurveLinear,
                    animations: { [unowned self] in
                        self.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.60, 0.60), CGFloat(-M_PI-0.1))
                    },
                    completion: { [unowned self] finished in
                        UIView.animateWithDuration(
                            0.14,
                            delay: 0.0,
                            options: .CurveLinear,
                            animations: { [unowned self] in
                                self.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.0, 1.0), CGFloat(-0.1))
                            },
                            completion: { [unowned self] finished in
                                self.vanish(count: count)
                            }
                        )
                    }
                )

            }
        )
    }

    private func vanish(count count: Int) {
        self.transform = CGAffineTransformIdentity

        UIView.animateWithDuration(
            0.5,
            delay: 0.1,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                let scale = CGFloat(1.2*sin(M_PI_2))
                self.transform = CGAffineTransformMakeScale(scale, scale)
                self.alpha = sin(0.0)
            },
            completion: { [unowned self] finished in
                self.transform = CGAffineTransformIdentity
                self.alpha = 1.0

                let next = count - 1
                self.countDown(count: next)
            }
        )
    }

    private func go() {
        self.text = "Go!"
        self.alpha = 1.0
        self.transform = CGAffineTransformMakeScale(7.5, 7.5)

        UIView.animateWithDuration(
            0.13,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { [unowned self] in
                let scale = CGFloat(sin(M_PI_2))
                self.transform = CGAffineTransformMakeScale(scale, scale)
            },
            completion: { [unowned self] finished in

                UIView.animateWithDuration(
                    0.7,
                    delay: 0.20,
                    options: .CurveEaseOut,
                    animations: { [unowned self] in
                        let scale = CGFloat(sin(M_PI_2))
                        self.transform = CGAffineTransformMakeScale(scale, scale)
                        self.alpha = sin(0.0)
                    },
                    completion: { [unowned self] finished in
                        self.completionHandler()
                    }
                )

            }
        )
    }


}
