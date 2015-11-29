(function(global) {
    "use strict;"

    /// constants
    var EVENTS = {
        START : 'start',
        FINISH : 'finish',
        MORE_THAN_MAX : 'more than max'
    };


    /// modules
    var util = require('util');
    var events = require('events');
    var Player = require("./Player.js");


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
        }
        else {
            this.emit(EVENTS.MORE_THAN_MAX, 'This game has max players.');
        }
    };


    /// Exports

    if ("process" in global) {
        module.exports = Game;
    }
    global.Game = Game;

})((this || 0).self || global);
