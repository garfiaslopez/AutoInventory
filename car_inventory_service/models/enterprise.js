//PACKAGES:
var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var bcrypt = require("bcrypt-nodejs");
var mongoosePaginate = require('mongoose-paginate');

var EnterpriseSchema = new Schema({
	account_id: {
		type: Schema.ObjectId,
		ref: 'Account',
		required: true
	},
	denomination: {
		type: String,
		required: true
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
    },
    status: {
    	type: Boolean,
    	default: true
    }
});

EnterpriseSchema.plugin(mongoosePaginate);

//Return the module
module.exports = mongoose.model("Enterprise",EnterpriseSchema);
