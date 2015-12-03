/// constants
const MAX_PLAYERS = 1;


/// modules
var Game = require('./modules/Game.js');
var server = require('http').createServer();
var io = require('socket.io')(server);


/// variables
var port = process.env.PORT || 3000;
var game = new Game(MAX_PLAYERS);


/// events
io.on('connection', function(socket) {

    /// socket.io
    socket.on('disconnect', function() {
        console.log('disconnected: ' + socket.id);
    });

    socket.on('event', function(event) {
        console.log('event: ' + event);
        game.handleEvent(event, socket.id);
    });


    /// game
    game.on('join', function(players) {
        socket.emit('join', players);
    });

    game.on('more than max number of players', function(players) {
        socket.emit('more than max number of players', players);
    });

    game.on('start', function(players) {
        socket.emit('start', players);
        socket.broadcast.emit('start', players);
    });
})

server.listen(port);
