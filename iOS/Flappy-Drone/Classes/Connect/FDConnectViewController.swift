import UIKit


/// MARK: - FDConnectViewController
class FDConnectViewController: UIViewController {

    /// MARK: - properties

    var drones: [ARService] = []

    @IBOutlet weak var droneButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!


    /// MARK: - life cycle

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // discover drone
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("ARDiscoveredNotification:"),
            name: FDNotificationCenter.ARDiscoveryNotificationServicesDevicesListUpdated,
            object: nil
        )
        ARDiscovery.sharedInstance().start()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
        ARDiscovery.sharedInstance().stop()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == FDNSStringFromClass(FDRaceViewController)) {
            let socket = sender as! SIOSocket
            let vc = segue.destinationViewController as! FDRaceViewController
            vc.socket = socket
        }
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
        if button == self.connectButton { self.connect() }
        if button == self.droneButton { }
    }


    /// MARK: - notification

    /**
     * called when drone is discovered
     * @param notification NSNotification
     **/
    func ARDiscoveredNotification(notification: NSNotification) {
        let userInfo = notification.userInfo
        if userInfo == nil { return }
        let services = userInfo![kARDiscoveryServicesList] as? [ARService]
        if services == nil { return }

        self.drones = services!
        let title = (self.drones.count > 0) ? self.drones[0].name : "none"
        self.droneButton.setTitle("your drone: \(title)", forState: .Normal)
    }


    /// MARK: - private api

    /**
     * connect web socket and drone
     **/
    private func connect() {
        if self.drones.count == 0 { return }

        // drone
        let succeeded = FDDrone.sharedInstance().connectWithService(self.drones[0])
        if !succeeded { return }

        // web socket
        self.connectWebSocket(
            successHandler: { [unowned self] (socket: SIOSocket) -> Void in
                dispatch_async(dispatch_get_main_queue(), { [unowned self] () -> Void in
                    self.performSegueWithIdentifier(FDNSStringFromClass(FDRaceViewController), sender: socket)
                })
            },
            failureHandler: { () -> Void in
                FDDrone.sharedInstance().disconnect()
            }
        )
    }

    /**
     * connect web socket
     * @param successHandler called when websocket connection is succeeded
     * @param failureHandler called when websocket connection is failed
     **/
    private func connectWebSocket(successHandler successHandler: (socket: SIOSocket) -> Void, failureHandler: () -> Void) {
        SIOSocket.socket(response: { (socket: SIOSocket!) -> Void in
            socket.onConnect = { () -> Void in
                successHandler(socket: socket)
            }
            socket.onError = { (errorInfo: [NSObject : AnyObject]!) -> Void in
                failureHandler()
            }
            socket.onDisconnect = { () -> Void in
                failureHandler()
            }
        })
    }
}
