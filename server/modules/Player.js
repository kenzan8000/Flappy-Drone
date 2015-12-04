(function(global) {
    'use strict;'

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
        this.currentLocation = {x: this.currentLocation.x+move, y: 0, z:0};
        this.moveCount++;
    }


    /// Exports
    if ('process' in global) {
        module.exports = Player;
    }
    global.Player = Player;

})((this || 0).self || global);
