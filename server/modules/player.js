/// Player
function Player(sessionID) {
    this.sessionID = sessionID;
    this.currentLocation = {x: 0, y: 0, z:0};
}


/// public api

/**
 * set currentLocation
 * @param location {x: number, y: number, z: number}
 **/
Player.prototype.setCurrentLocation = function setCurrentLocation(location) {
    this.currentLocation = location;
};


module.exports = Player;

