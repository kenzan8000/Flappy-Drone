import UIKit


class ViewController: UIViewController {

    var socket: SIOSocket?

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mashButton: UIButton!

    @IBOutlet weak var countDownLabel: FDCountDownLabel!


    override func loadView() {
        super.loadView()

        self.joinButton.hidden = false
        self.startButton.hidden = true
        self.mashButton.hidden = true

        self.countDownLabel.completionHandler = { [unowned self] in
            self.mashButton.hidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SIOSocket.socketWithHost(
            //"http://localhost:3000",
            "http://ardrone:3000",
            response: { [unowned self] (socket: SIOSocket!) -> Void in
                self.socket = socket

                self.socket!.onConnect = { () -> Void in
                    print("connected")
                }

                self.socket!.onDisconnect = { () -> Void in
                    print("disconnected")
                }

                self.socket!.on("join", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    self.startButton.hidden = false
                    print("join: \(players)")
                })

                self.socket!.on("more than max number of players", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    self.joinButton.hidden = false
                    print("more than max number of players: \(players)")
                })

                self.socket!.on("start", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    self.countDownLabel.countDown(count: 3)
                    print("start: \(players)")
                })
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func touchedUpInside(button button: UIButton) {
        if self.socket == nil { return; }

        if button == self.joinButton {
            self.joinButton.hidden = true
            self.socket!.emit("event", args: [["join"]])
        }
        else if button == self.startButton {
            self.startButton.hidden = true
            self.socket!.emit("event", args: [["start"]])
        }
        else if button == self.mashButton {
        }
    }

}
