import UIKit


/// MARK: - FDViewController
class FDViewController: UIViewController {

    /// MARK: - properties

    var socket: SIOSocket?
    var mashCount = 0

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mashButton: UIButton!

    @IBOutlet weak var countDownLabel: FDCountDownLabel!
    @IBOutlet weak var debugLabel: UILabel!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        self.joinButton.hidden = false
        self.startButton.hidden = true
        self.mashButton.hidden = true

        self.countDownLabel.completionHandler = { [unowned self] in
            self.mashButton.hidden = false
            self.moveDrone()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SIOSocket.socketWithHost(
            //"http://localhost:3000",
            "http://kenzan8000.local:3000",
            response: { [unowned self] (socket: SIOSocket!) -> Void in
                self.socket = socket

                self.socket!.onConnect = { [unowned self] in
                    self.setDebugText("connected")
                }

                self.socket!.onError = { [unowned self] (errorInfo: [NSObject : AnyObject]!) -> Void in
                    self.setDebugText("\(errorInfo)")
                }

                self.socket!.onDisconnect = { [unowned self] in
                    self.setDebugText("disconnected")
                }


                self.socket!.on("join", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                        if (self.joinButton.hidden) { self.startButton.hidden = false }
                    })
                    self.setDebugText("join\n\(players)")
                })

                self.socket!.on("more than max number of players", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                        self.joinButton.hidden = false
                    })
                    self.setDebugText("more than max number of players\n\(players)")
                })

                self.socket!.on("start", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                        self.countDownLabel.countDown(count: 3)
                    })
                    self.setDebugText("start\n\(players)")
                })

                self.socket!.on("move", callback: { [unowned self] (players: [AnyObject]!) -> Void in
                    self.moveDrone()
                    self.setDebugText("move\n\(players)")
                })

            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

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
            self.mashCount++
        }
    }


    /// MARK: - private api

    /**
     * move drone
     **/
    private func moveDrone() {
        self.mashCount = 0

        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(),
            { [unowned self] in
                self.socket!.emit("event", args: [["move" : "\(self.mashCount)"]])
            }
        )
    }

    /**
     * set debug text
     * @param text String
     **/
    private func setDebugText(text: String) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
            self.debugLabel.text = text
        })
    }

}
