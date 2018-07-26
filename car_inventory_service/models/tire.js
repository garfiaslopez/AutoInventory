var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var mongoosePaginate = require('mongoose-paginate');

var TireSchema = new Schema({
    enterprise_id: {
		type: Schema.ObjectId,
		ref: 'Enterprise',
		required: true
	},
    brand: {
        type: String,
    },
    size: {
        first: {
            type: Number
        },
        second: {
            type: Number
        },
        third: {
            type: Number
        }
    },
    season: {
        type: String,
    },
    stock: {
        type: Number,
        default: 0
    },
    created: {
        type: Date,
        default: Date.now
    }
});

TireSchema.index({
	brand: 'text',
	season: 'text'
});

TireSchema.plugin(mongoosePaginate);


//Return the module
module.exports = mongoose.model("Tire", TireSchema);
