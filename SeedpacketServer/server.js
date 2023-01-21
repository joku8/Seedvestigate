const express = require('express');
// const { MongoParseError, ReturnDocument } = require('mongodb');
const mongoose = require('mongoose');
// const { stringify } = require('querystring');
var app = express();

var Data = require('./packetSchema');

mongoose.connect('mongodb://localhost/mydb')

mongoose.connection.once('open', () => {

    console.log('Connection has been made!!!');

}).on('error', (error) => {

    console.log('Connection error: ' + error);

})

// CREATE A PACKET
// POST request
app.post("/create", (req, res) => {
    // console.log(req.query);
    var packet = new Data({
        plant: req.query.plant,
        variety: req.query.variety,
        source: req.query.source
    })    

    // console.log('Packet saved: ' + packet.plant + ' ' + packet.variety + ' ' + packet.source);

    // Check for duplicate packets
    Data.find({plant: packet.plant, variety: packet.variety, source: packet.source}).then((DBitems) => {
        if (DBitems.length > 0) {
            console.log('Duplicate packet');
            res.send('Duplicate packet');
        } else {
            packet.save().then(() => {
                if (packet.isNew == false) {
                    res.send('Packet saved');
                } else {
                    console.log('Failed to save packet');
                }
            })
        }
    })
})

// http://127.0.0.1/create
var server = app.listen(8081, "127.0.0.1", () => {
    console.log('Server running at http://127.0.0.1:8081/')
})

// FETCH 
// GET request
// http://127.0.0.1:8081/fetch
app.get('/fetch', (req, res) => {
    console.log('Fetching packets');
    Data.find({}).then((DBitems) => {
        res.send(DBitems);
    })
})

// DELETE A PACKET
// POST request
// http://127.0.0.1:8081/delete
app.post('/delete', (req, res) => {
    console.log('Deleting packet');
    Data.findOneAndRemove({
        _id: req.query.id
    }, (err) => {
        if (err) {
            console.log("FAILED: " + err);
        }
    })

    res.send('Packet deleted');
})

// UPDATE A PACKET
// POST request
// http://127.0.0.1:8081/update
app.post('/update', (req, res) => {
    console.log('Updating packet');
    Data.findOneAndUpdate({
        _id: req.query.id
    },{
        plant: req.query.plant,
        variety: req.query.variety,
        source: req.query.source
    }, (err) => {
        console.log("FAILED: " + err);
    })
    res.send('Packet updated');
})

// CLEAR ALL PACKETS
// POST request
// http://127.0.0.1:8081/clear
app.post('/clear', (req, res) => {
    console.log('Deleting all packets');
    Data.deleteMany({}, (err) => {
        if (err) {
            console.log("FAILED: " + err);
        }
    })

    res.send('All packets deleted');
})




