var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var mongoosePaginate = require('mongoose-paginate');

var PendingSchema = new Schema({
	enterprise_id: {
		type: Schema.ObjectId,
		ref: 'Enterprise',
		required: true
	},
	user_id: {
		type: Schema.ObjectId,
		ref: 'User'
	},
	car_id: {
		type: Schema.ObjectId,
		ref: 'Car',
		required: false
	},
    denomination: {
		type: String,
		trim: true,
		required: true,
	},
    is_done: {
        type: Boolean,
        default: false
    },
	date: {
		type: Date
	},
	created: {
		type: Date,
		default: Date.now
	}
});

PendingSchema.index({
	denomination: 'text'
});

PendingSchema.plugin(mongoosePaginate);

//Return the module
module.exports = mongoose.model("Pending",PendingSchema);
