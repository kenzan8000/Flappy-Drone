import UIKit


/// MARK: - FDRaceViewController
class FDRaceViewController: UIViewController {

    /// MARK: - properties

    var socket: SIOSocket!
    var mashCount = 0

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mashButton: UIButton!

    @IBOutlet weak var countDownLabel: FDCountDownLabel!
    @IBOutlet weak var debugLabel: UILabel!

    @IBOutlet weak var takeoffButton: UIButton!
    @IBOutlet weak var landButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()

        // UI
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

        self.socket.on("join", callback: { [unowned self] (players: [AnyObject]!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                if (self.joinButton.hidden) { self.startButton.hidden = false }
            })
            self.setDebugText("join\n\(players)")
        })

        self.socket.on("more than max number of players", callback: { [unowned self] (players: [AnyObject]!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                self.joinButton.hidden = false
            })
            self.setDebugText("more than max number of players\n\(players)")
        })

        self.socket.on("start", callback: { [unowned self] (players: [AnyObject]!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                self.countDownLabel.countDown(count: 3)
            })
            self.setDebugText("start\n\(players)")
        })

        self.socket.on("move", callback: { [unowned self] (players: [AnyObject]!) -> Void in
            self.moveDrone()
            self.setDebugText("move\n\(players)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    /**
     * called when button is touched up inside
     * @param button UIButton
     **/
    @IBAction func touchedUpInside(button button: UIButton) {
        if button == self.joinButton {
            self.joinButton.hidden = true
            self.socket.emit("event", args: [["join"]])
        }
        else if button == self.startButton {
            self.startButton.hidden = true
            self.socket.emit("event", args: [["start"]])
        }
        else if button == self.takeoffButton {
            FDDrone.sharedInstance().takeoff()
        }
        else if button == self.landButton {
            FDDrone.sharedInstance().land()
        }
        else if button == self.upButton {
            FDDrone.sharedInstance().stopGazUp()
        }
        else if button == self.downButton {
            FDDrone.sharedInstance().stopGazDown()
        }
    }

    /**
     * called when button is touched down
     * @param button UIButton
     **/
    @IBAction func touchedDown(button button: UIButton) {
        if button == self.mashButton {
            self.mashCount++
        }
        else if button == self.upButton {
            FDDrone.sharedInstance().startGazUp()
        }
        else if button == self.downButton {
            FDDrone.sharedInstance().startGazDown()
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
                self.socket.emit("event", args: [["move" : "\(self.mashCount)"]])
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
