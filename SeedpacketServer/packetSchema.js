var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var packet = new Schema({
    plant: String,
    variety: String,
    source: String
})

const Data = mongoose.model('Data', packet);

module.exports = Data;
