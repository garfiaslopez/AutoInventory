//PACKAGES:
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var bcrypt = require("bcrypt-nodejs");

var AccountSchema = new Schema({
	denomination: {
        type: String
    },
    fiscalData:{
        name: { type: String },
        phone: { type: String },
        address: { type: String },
        rfc: { type: String }
    },
    paymethod: {
    },
    status: {
		type: String,
		default: 'normal'
    },
	created: {
		type: Date,
		default: Date.now
	}
});

//Return the module
module.exports = mongoose.model("Account",AccountSchema);
