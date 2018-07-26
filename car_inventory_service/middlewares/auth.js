//JSONWEBTOKEN
var jwt = require("jsonwebtoken");

//Config File
var Config = require("./../config/config");
var KeyToken = Config.key;
var Log = require('../config/system/winston');
var mongoose = require("mongoose");
var UserModel = require("../models/user");

module.exports = {
	isAuthenticated: function(req,res,next){
		var token = req.headers.authorization;
		if(token){
			jwt.verify(token,Config.key,{ignoreExpiration:true},function(err,decoded){
				if(err){
					return res.send({success:false,message:"Corrupt Token."});
				}else{
					req.decoded = decoded;
					next();
				}
			});
		}else{
			return res.send({success:false,message:"No token provided."});
		}
	}
};
