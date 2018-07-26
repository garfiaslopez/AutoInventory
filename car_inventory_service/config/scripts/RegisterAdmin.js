var mongoose = require("mongoose");
var Schema = mongoose.Schema;

process.env.NODE_ENV = process.env.NODE_ENV || 'development';

var config = require('../config');



/* MONGO DB

db.createUser(
  {
    user: "garfiaslopez",
    pwd: "RuHQWmbunTN4gHEf",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)


db.createUser(
    {
      user: "Enun2x3SuperUser",
      pwd: "CLttFUZthSanAKvm",
      roles: [
         { role: "readWrite", db: "Nun2x3" }
      ]
    }
)

*/

// Bootstrap MongoDB connection
var dbMongo = mongoose.connect(config.dbMongo);
var key = config.key;

var UserSchema = new Schema({

	carwash_id: {
		type: String,
	},
	username: {
		type: String,
		trim: true,
		required: true,
	},
	password: {
		type: String,
		required: true,
		select: false
	},
	rol: {
		type: String,
		default:"superadmin",
		required: true,
	},
	info:{
		name: String,
		phone: String,
		address: String,
		birth: Date
	},
    created: {
        type: Date,
        default: Date.now
    }

});

var AdminModel = mongoose.model('User', UserSchema);

var Administrador = new AdminModel({

	username: "garfiaslopez",
	password: "jose12",
	info: {
		name: "Jose De Jesus Garfias Lopez",
		phone: "5591873207",
		address: "Mi casa",
		birth: Date.now()
	}

});

Administrador.save(function(err){

	if(err){
		//entrada duplicada
		if(err.code == 11000){
			console.log("ERROR THAT USER ALREADY EXISTS");
		}else{
			return console.log(err);
		}
	}
	console.log("SUCCESFULLY ADMIN REGISTRATION");
});
