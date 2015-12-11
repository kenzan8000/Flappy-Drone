(function(global) {
    'use strict;'

    const MAX_VALUE = 2.0
    const MIN_VALUE = 0.0

    /// Player
    function Player(sessionID) {
        this.sessionID = sessionID;
        this.currentLocation = {x: 0, y: 0, z:0.5};
        this.isReady = false;
        this.moveCount = 0;
    }


    /// public api

    /**
     * set ready to start game
     * @param isReady Boolean
     **/
    Player.prototype.setReady = function(isReady) { this.isReady = isReady; }

    /**
     * move
     * @param move number
     **/
    Player.prototype.move = function(move) {
        var value = this.currentLocation.x + move / 100.0;
        if (value > MAX_VALUE) { value = 2.0; }
        else if (value < MIN_VALUE) { value = 0.0; }
        this.currentLocation = {
            x: value,
            y: this.currentLocation.y,
            z: this.currentLocation.z
        };
        this.moveCount++;
    }


    /// Exports
    if ('process' in global) {
        module.exports = Player;
    }
    global.Player = Player;

})((this || 0).self || global);
