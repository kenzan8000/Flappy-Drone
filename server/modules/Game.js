(function(global) {
    'use strict;'

    /// constants
    var EVENTS = {
        START : 'start',
        MORE_THAN_MAX_NUMBER_OF_PLAYERS : 'more than max number of players'
    };


    /// modules
    var util = require('util');
    var events = require('events');
    var Player = require('./Player.js');


    /// Game
    function Game(maxNumberOfPlayers) {
        events.EventEmitter.call(this);

        this.MAX_NUMBER_OF_PLAYERS = maxNumberOfPlayers;
        this.players = [];
    };
    util.inherits(Game, events.EventEmitter);


    /// public api

    /**
     * handle event
     * @param event event
     * @param sessionID socket.io session ID
     **/
    Game.prototype.handleEvent = function(event, sessionID) {
        var player = this.getPlayer(sessionID);

        switch (event.kind) {
            case 'join':
                this.setPlayer(sessionID);
                break;

            case 'start':
                this.setPlayerReady(sessionID);
                if (player == null) { return; }
                if (this.allPlayersAreReady()) { this.emit(EVENTS.START, this.players); }
                break;
        }
    }

    /**
     * add player
     * @param sessionID socket.io session ID
     **/
    Game.prototype.setPlayer = function(sessionID) {
        if (this.players.length < this.MAX_NUMBER_OF_PLAYERS) {
            var player = new Player(sessionID);
            this.players.push(player);
        }
        else {
            this.emit(EVENTS.MORE_THAN_MAX_NUMBER_OF_PLAYERS, this.players);
        }
    };

    /**
     * get player
     * @param sessionID socket.io session ID
     * @return Player or null
     **/
    Game.prototype.getPlayer = function(sessionID) {
        for (var i = 0; i < this.players.count; i++) {
            var player = this.players[i];
            if (player.sessionID == sessionID) { return player; }
        }
        return null;
    }

    /**
     * make player ready
     * @param sessionID socket.io session ID
     **/
    Game.prototype.setPlayerReady = function(sessionID) {
        var player = this.getPlayer(sessionID);
        if (play != null) { player.isReady = true; }
    }

    /**
     * all players are ready?
     * @return Boolean
     **/
    Game.prototype.allPlayersAreReady = function() {
        for (var i = 0; i < this.players.count; i++) {
            var player = this.players[i];
            if (!player.isReady) { return false }
        }
        return true;
    }


    /// Exports
    if ('process' in global) {
        module.exports = Game;
    }
    global.Game = Game;

})((this || 0).self || global);
