/// constants
const MAX_PLAYERS = 0

/// modules
var player = require("./modules/player.js"); // game player
var server = require('http').createServer();
var io = require('socket.io')(server);

/// variables
var port = process.env.PORT || 3000;
var players = [];

/// web socket
io.on('connection', function(socket) {

    console.log('connected: ' + socket.id);
    if (players.count < MAX_PLAYERS) {
        players.push(new player(socket.id));
    }
    else {
        socket.disconnect();
    }

    socket.on('disconnect', function() {
        console.log('disconnected: ' + socket.id);
        console.log(socket.id);
    });

    socket.on('ready', function(data) {
        console.log(data);
    });

    socket.on('fly', function(data) {
        console.log(data);
    });
});
server.listen(port);
