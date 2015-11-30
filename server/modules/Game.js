(function(global) {
    'use strict;'

    /// constants
    var EVENTS = {
        START : 'start',
        END : 'end',
        MORE_THAN_MAX_PLAYERS : 'more than max players'
    };


    /// modules
    var util = require('util');
    var events = require('events');
    var Player = require('./Player.js');


    /// Game
    function Game(maxPlayers) {
        events.EventEmitter.call(this);

        this.MAX_PLAYERS = maxPlayers;
        this.players = [];
    };
    util.inherits(Game, events.EventEmitter);


    /// public api

    /**
     * add player
     * @param sessionID socket.io session ID
     **/
    Game.prototype.addPlayer = function(sessionID) {
        if (this.players.length < this.MAX_PLAYERS) {
            var player = new Player(sessionID);
            this.players.push(player);
            if (this.players.length == this.MAX_PLAYERS) {
                this.emit(EVENTS.START, 'Game is starting.');
            }
        }
        else {
            this.emit(EVENTS.MORE_THAN_MAX_PLAYERS, 'This game already has max players.');
        }
    };


    /// Exports
    if ('process' in global) {
        module.exports = Game;
    }
    global.Game = Game;

})((this || 0).self || global);
