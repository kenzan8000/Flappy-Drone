/// constants
const MAX_PLAYERS = 2;


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
        socket.emit('disconnect');
    });

    socket.on('event', function(event) {
        console.log('event: ' + event);
        game.handleEvent(event, socket.id);
    });


    /// game
    game.on('start', function(players) {
        console.log('start: ' + players)
        socket.broadcast.emit({'start' : players});
    });

    game.on('end', function(players) {
        console.log('end: ' + players)
        socket.broadcast.emit({'end' : players});
    });

    game.on('more than max number of players', function(players) {
        socket.emit({'more than max number of players' : players});
    });
})

server.listen(port);
