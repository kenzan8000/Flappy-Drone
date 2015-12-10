(function(global) {
    'use strict;'

    const MAX_HEIGHT = 2.0
    const MIN_HEIGHT = 0.5

    /// Player
    function Player(sessionID) {
        this.sessionID = sessionID;
        this.currentLocation = {x: 0, y: 0, z:0};
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
        var height = this.currentLocation.z + move / 100.0;
        if (height > MAX_HEIGHT) { height = 2.0; }
        else if (height < MIN_HEIGHT) { height = 0.0; }
        this.currentLocation = {
            x: this.currentLocation.x,
            y: this.currentLocation.y,
            z: height
        };

        this.moveCount++;
    }


    /// Exports
    if ('process' in global) {
        module.exports = Player;
    }
    global.Player = Player;

})((this || 0).self || global);
