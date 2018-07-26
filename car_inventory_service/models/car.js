var Config = require("../config/config");

var mongoose = require("mongoose");
var Schema = mongoose.Schema;
var autoIncrement = require('mongoose-auto-increment');
var mongoosePaginate = require('mongoose-paginate');

var connection = mongoose.createConnection(Config.dbMongo);
autoIncrement.initialize(connection);


var CarSchema = new Schema({
	enterprise_id: {
		type: Schema.ObjectId,
		ref: 'Enterprise',
		required: true
	},
	year: {
		type: Number
	},
	year_text: {
		type: String
	},
	make: {
		type: String
	},
	model: {
		type: String
	},
	color: {
		type: String
	},
	color_interior: {
		type: String
	},
	vin: {
		type: String
	},
	folio: {
		type: Number
	},
	folio_text: {
		type: String
	},
	kilometers: {
		type: Number
	},
	transmission: {
		type: String
	},
	drive_train: {
		type: String
	},
	opidi: {
		type: String
	},
	opidi_done: {
		type: Boolean
	},
	price: {
		total: Number,
		payment: {
			period: { type: String },
			total: { type: Number }
		}
	},
	arrival: {
		type: Date
	},
	delivery: {
		type: Date
	},
	advertising: [{
		type: String
	}],
	pictures_taken: {
		type: Boolean
	},
	detailing_done: {
		type: Boolean
	},



	front_brakes: {
		type: Number
	},
	rear_brakes: {
		type: Number
	},
	front_rotors: {
		type: String
	},
	rear_rotors: {
		type: String
	},
	leaks: {
		type: Boolean
	},
	engine_oil: {
		type: Boolean
	},
	coolant: {
		type: Boolean
	},
	air_con: {
		type: Boolean
	},
	air_heat: {
		type: Boolean
	},
	dash_lights: {
		type: Boolean
	},


	scratches: {
		type: Boolean
	},
	dent: {
		type: Boolean
	},
	lights: {
		type: Boolean
	},
	wheels: {
		type: Boolean
	},
	tire_size: {
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
	notes: {
		type: String
	},

	is_delivery: {
		default: false,
		type: Boolean
	},

    created: {
        type: Date,
		default: Date.now
    }
});

CarSchema.plugin(autoIncrement.plugin, {
	model: 'Car',
	field: 'folio',
	startAt: 1,
    incrementBy: 1
});

CarSchema.pre('save', function (next){
  	this['folio_text'] = 'aws' + this.folio;
  	next();
});

CarSchema.index({
	make: 'text',
	model: 'text',
	notes: 'text',
	vin: 'text',
	year_text: 'text',
	folio_text: 'text'
});

CarSchema.plugin(mongoosePaginate);

//Return the module
module.exports = mongoose.model("Car",CarSchema);
