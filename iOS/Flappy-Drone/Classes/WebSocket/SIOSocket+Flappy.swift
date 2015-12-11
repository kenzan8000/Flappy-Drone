import UIKit


/// MARK: - SIOSocket+Flappy
extension SIOSocket {

    /// MARK: - properties


    /// MARK: - initializer


    /// MARK: - class method

    /**
     * create web socket
     * @param response handler when response is received
     **/
    class func socket(response response: (socket: SIOSocket!) -> Void) {
        SIOSocket.socketWithHost(
            "http://kenzan8000.local:3000",
            response: { (socket: SIOSocket!) -> Void in
                response(socket: socket)
            }
        )
    }


    /// MARK: - public api

    /**
     * get session ID
     * @return session ID string
     **/
    func sessionID() -> String {
        return "\(self.javascriptContext.objectForKeyedSubscript("objc_socket").objectForKeyedSubscript("io").objectForKeyedSubscript("engine").objectForKeyedSubscript("id"))"
    }

}
