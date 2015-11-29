/// constants
const MAX_PLAYERS = 2;


/// modules
var Game = require("./modules/Game.js");
var server = require('http').createServer();
var io = require('socket.io')(server);


/// variables
var port = process.env.PORT || 3000;
var game = new Game(MAX_PLAYERS);


/// event
io.on('connection', function(socket) {

    /// socket.io
    socket.on('disconnect', function() {
        console.log('disconnected: ' + socket.id);
        console.log(socket.id);
    });

    socket.on('event', function(data) {
    });


    /// game
    game.on('more than max', function(message) {
        socket.disconnect();
    });

    game.addPlayer(socket.id);

});

server.listen(port);

