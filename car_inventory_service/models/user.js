//PACKAGES:
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var bcrypt = require("bcrypt-nodejs");

var UserSchema = new Schema({
	account_id: {
		type: Schema.ObjectId,
		ref: 'Account',
		required: true
	},
	username: {
		type: String,
		trim: true,
		required: true,
        unique: true
	},
	password: {
		type: String,
		required: true
	},
	email: {
		type: String
	},
	rol: {
		type: String,
		default: "user",
		required: true,
	},
	push_id: {
		type: String
	},
	name: {
		type: String
	},
	phone: {
		type: String
	},
	address: {
		type: String
	},
    created: {
        type: Date,
		default: Date.now
    }
});

module.exports = mongoose.model("User",UserSchema);
