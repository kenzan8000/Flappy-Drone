import UIKit


class ViewController: UIViewController {


    @IBOutlet weak var countDownLabel: FDCountDownLabel!
    @IBOutlet weak var startButton: QBFlatButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        //self.countDownLabel.completionHandler = { [unowned self] in
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func touchedUpInside(button button: UIButton) {
        self.countDownLabel.countDown(count: 3)
    }

}

