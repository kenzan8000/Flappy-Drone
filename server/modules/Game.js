(function(global) {
    'use strict;'

    /// constants
    var EVENTS = {
        JOIN : 'join',
        MORE_THAN_MAX_NUMBER_OF_PLAYERS : 'more than max number of players',
        START : 'start',
        MOVE : 'move'
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

        if (event == 'join' && player == null) {
            this.setPlayer(sessionID);
        }
        else if (event == 'start') {
            if (player == null) { return; }
            player.setReady(true);
            if (this.allPlayersAreReady()) { this.emit(EVENTS.START, sessionID, this.players); }
        }
        else if ('move' in event) {
            var move = parseFloat(event['move']);
            if (!isNaN(move)) { player.move(move); }
            if (this.allPlayersMoveCountsAreSame()) {
                this.emit(EVENTS.MOVE, sessionID, this.players);
            }
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
            this.emit(EVENTS.JOIN, sessionID, this.players);
        }
        else {
            this.emit(EVENTS.MORE_THAN_MAX_NUMBER_OF_PLAYERS, sessionID, this.players);
        }
    };

    /**
     * get player
     * @param sessionID socket.io session ID
     * @return Player or null
     **/
    Game.prototype.getPlayer = function(sessionID) {
        for (var i = 0; i < this.players.length; i++) {
            var player = this.players[i];
            if (player.sessionID == sessionID) { return player; }
        }
        return null;
    }

    /**
     * remove player
     * @param sessionID socket.io session ID
     **/
    Game.prototype.removePlayer = function(sessionID) {
        for (var i = 0; i < this.players.length; i++) {
            var player = this.players[i];
            if (player.sessionID == sessionID) {
                this.players.splice(i, 1);
                break;
            }
        }
    }

    /**
     * all players are ready to start game?
     * @return Boolean
     **/
    Game.prototype.allPlayersAreReady = function() {
        if (this.players.length != this.MAX_NUMBER_OF_PLAYERS) { return false; }
        for (var i = 0; i < this.players.length; i++) {
            var player = this.players[i];
            if (!player.isReady) { return false }
        }
        return true;
    }

    /**
     * all players' move counts are same?
     * @return Boolean
     **/
    Game.prototype.allPlayersMoveCountsAreSame = function() {
        for (var i = 1; i < this.players.length; i++) {
            if (this.players[i].moveCount != this.players[i-1].moveCount) { return false; }
        }
        return true;
    }


    /// Exports
    if ('process' in global) {
        module.exports = Game;
    }
    global.Game = Game;

})((this || 0).self || global);
