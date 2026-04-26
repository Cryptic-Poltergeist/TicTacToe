const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const Room = require("./modules/room");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const io = require('socket.io')(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  }
  });

const DB = "mongodb+srv://EphraimJason:testpassword@cluster0.kalqepd.mongodb.net/?appName=Cluster0";

app.use(express.json());

io.on('connection', (socket) => {
    console.log('A user connected: ', socket.id);

    socket.on('createRoom', async ({ nickname }) => {
        console.log(nickname);

        try {
            let room = new Room();
            let player = {
                socketID: socket.id,
                nickname: nickname,
                playerType: "X",
            };

            room.players.push(player);
            room.turn = player;
            room = await room.save();

            console.log(room);

            const roomID = room._id.toString();
            socket.join(roomID);

            io.to(roomID).emit('createRoomSuccess', room);

        } catch (e) {
            console.log(e);
            socket.emit('errorOccurred', 'Something went wrong while creating the room.');
        }
    });

    socket.on('joinRoom', async ({ nickname, roomId }) => {
        try {
            if (!mongoose.Types.ObjectId.isValid(roomId)) {
                socket.emit('errorOccurred', 'Please enter a valid room ID.');
                return;
            }

            let room = await Room.findById(roomId);

            if (!room) {
                socket.emit('errorOccurred', 'Room not found.');
                return;
            }

            if (!room.isJoin || room.players.length >= room.occupancy) {
                socket.emit('errorOccurred', 'The game is already in progress.');
                return;
            }

            const player = {
                socketID: socket.id,
                nickname,
                playerType: "O",
            };

            socket.join(roomId);
            room.players.push(player);
            room.isJoin = false;
            room = await room.save();

            io.to(roomId).emit('joinRoomSuccess', room);
            io.to(roomId).emit('updatePlayers', room.players);
            io.to(roomId).emit('updateRoom', room);
        } catch (e) {
            console.log(e);
            socket.emit('errorOccurred', 'Something went wrong while joining the room.');
        }
    });

    socket.on('tap', async ({ index, roomId }) => {
        try {
            let room = await Room.findById(roomId);

            if (!room) {
                socket.emit('errorOccurred', 'Room not found.');
                return;
            }

            if (room.turn.socketID !== socket.id) {
                socket.emit('errorOccurred', 'It is not your turn.');
                return;
            }

            const choice = room.turn.playerType;

            if (room.turnIndex === 0) {
                room.turn = room.players[1];
                room.turnIndex = 1;
            } else {
                room.turn = room.players[0];
                room.turnIndex = 0;
            }

            room = await room.save();

            io.to(roomId).emit('tapped', {
                index,
                choice,
                room,
            });
        } catch (e) {
            console.log(e);
            socket.emit('errorOccurred', 'Something went wrong while making the move.');
        }
    });

    socket.on('winner', async ({ winnerSocketId, roomId }) => {
        try {
            let room = await Room.findById(roomId);

            if (!room) {
                socket.emit('errorOccurred', 'Room not found.');
                return;
            }

            const player = room.players.find(
                (currentPlayer) => currentPlayer.socketID === winnerSocketId
            );

            if (!player) {
                socket.emit('errorOccurred', 'Winner not found.');
                return;
            }

            player.points += 1;
            room = await room.save();

            if (player.points >= room.maxRounds) {
                const winner = player.toObject ? player.toObject() : { ...player };

                io.to(roomId).emit('endGame', {
                    winner,
                    room,
                    players: room.players,
                });
            } else {
                io.to(roomId).emit('pointIncrease', player);
            }
        } catch (e) {
            console.log(e);
            socket.emit('errorOccurred', 'Something went wrong while updating points.');
        }
    });

    socket.on('resetMatch', async ({ roomId }) => {
        try {
            let room = await Room.findById(roomId);

            if (!room) {
                socket.emit('errorOccurred', 'Room not found.');
                return;
            }

            room.players.forEach((player) => {
                player.points = 0;
            });
            room.turn = room.players[0];
            room.turnIndex = 0;
            room = await room.save();

            io.to(roomId).emit('matchReset', {
                room,
                players: room.players,
            });
        } catch (e) {
            console.log(e);
            socket.emit('errorOccurred', 'Something went wrong while resetting the match.');
        }
    });

    socket.on('disconnect', () => {
        console.log('A user disconnected: ', socket.id);
    });
});

// DB connects first, then server starts
mongoose.connect(DB)
    .then(() => {
        console.log("Connected to database successfully");
        server.listen(port, '0.0.0.0', () => {
            console.log(`Server started and is running on port ${port}`);
        });
    })
    .catch((err) => {
        console.log("Error connecting to database: ", err);
    });
