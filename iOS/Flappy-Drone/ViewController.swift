import UIKit


class ViewController: UIViewController {

    var socket: SIOSocket?

    @IBOutlet weak var countDownLabel: FDCountDownLabel!
    @IBOutlet weak var startButton: QBFlatButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        //self.countDownLabel.completionHandler = { [unowned self] in
        //}

        SIOSocket.socketWithHost(
            "http://localhost:3000",
            response: { [unowned self] (socket: SIOSocket!) -> Void in
                self.socket = socket

                self.socket!.onConnect = { () -> Void in
                    print("connected")
                }

                self.socket!.onDisconnect = { () -> Void in
                    print("disconnected")
                }

                self.socket!.on("start", callback: { (args: [AnyObject]!) -> Void in
                    print(args)
                })

                self.socket!.on("end", callback: { (args: [AnyObject]!) -> Void in
                    print(args)
                })
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func touchedUpInside(button button: UIButton) {
        if self.socket == nil { return; }

        //self.socket!.emit("event", args: [["join"]])
        //endself.countDownLabel.countDown(count: 3)
    }

}
