/// constants
const MAX_NUMBER_OF_PLAYERS = 2;


/// modules
var Game = require('./modules/Game.js');
var server = require('http').createServer();
var io = require('socket.io')(server);


/// variables
var port = process.env.PORT || 3000;
var game = new Game(MAX_NUMBER_OF_PLAYERS);


/// events
io.on('connection', function(socket) {

    /// socket.io
    socket.on('disconnect', function() {
        game.removePlayer(socket.id);
        console.log('disconnected: ' + socket.id);
    });

    socket.on('event', function(event) {
        console.log('event: ' + event + ' ' + socket.id);
        game.handleEvent(event, socket.id);
    });


    /// game
    game.on('join', function(sessionID, players) {
        socket.emit('join', players);
    });

    game.on('more than max number of players', function(sessionID, players) {
        if (socket.id == sessionID) {
            socket.emit('more than max number of players', players);
        }
    });

    game.on('start', function(sessionID, players) {
        if (socket.id == sessionID) {
            socket.emit('start', players);
            socket.broadcast.emit('start', players);
        }
    });
})

server.listen(port);
