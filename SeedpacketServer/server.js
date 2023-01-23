SERVER_ADDRESS = '127.0.0.1'
// SERVER_ADDRESS = '10.0.2.105'

const { json } = require('express');
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
        source: req.query.source,
        notes: req.query.notes
    })    

    // console.log('Packet saved: ' + packet.plant + ' ' + packet.variety + ' ' + packet.source);

    // Check for duplicate packets
    Data.find({plant: packet.plant, variety: packet.variety, source: packet.source, notes: packet.notes}).then((DBitems) => {
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

// CREATE
var server = app.listen(8081, SERVER_ADDRESS, () => {
    console.log('Server running at http://' + SERVER_ADDRESS + ':8081');
})

// FETCH 
// GET request
app.get('/fetch', (req, res) => {
    console.log('Fetching packets');
    Data.find({}).then((DBitems) => {
        // console.log(JSON.stringify(DBitems));
        // res.setHeader('Content-Type', 'application/json');
        res.send(DBitems);
    })
})

// DELETE A PACKET
// POST request
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
app.post('/update', (req, res) => {
    console.log('Updating packet');
    Data.findOneAndUpdate({
        _id: req.query.id
    },{
        plant: req.query.plant,
        variety: req.query.variety,
        source: req.query.source,
        notes: req.query.notes
    }, (err) => {
        console.log("FAILED: " + err);
    })
    res.send('Packet updated');
})

// CLEAR ALL PACKETS
// POST request
app.post('/clear', (req, res) => {
    console.log('Deleting all packets');
    Data.deleteMany({}, (err) => {
        if (err) {
            console.log("FAILED: " + err);
        }
    })

    res.send('All packets deleted');
})




