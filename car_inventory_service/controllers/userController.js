var errs = require('restify-errors');
var UserModel = require("../models/user");

var mongoose = require("mongoose");
var Schema = mongoose.Schema;

module.exports = {
	Create: (req,res,next) => {
		if (req.body.username && req.body.password && req.body.account_id) {
			var User = new UserModel();

			User.username = req.body.username;
			User.password = req.body.password;
			User.account_id = req.body.account_id;

			if(req.body.name) {
				User.name = req.body.name;
			}
			if(req.body.email) {
				User.email = req.body.email;
			}
			if(req.body.phone) {
				User.phone = req.body.phone;
			}
			if(req.body.address) {
				User.address = req.body.address;
			}
			if(req.body.rol) {
				User.rol = req.body.rol;
			}
			if(req.body.push_id) {
				User.push_id = req.body.push_id;
			}
			User.save((err, newUser) => {
				if(err){
					if(err.code == 11000){
	                    return next(new errs.BadRequestError("Duply entry."));
	                }else{
	                    return next(new errs.InternalServerError(err));
	                }
				} else {
					return res.json({success: true , user: newUser, message:"Succesfully created."});
				}
			});
		} else {
			return next(new errs.BadRequestError("Missing parameters"));
		}
	},

	All: (req,res,next) => {
		UserModel.find().exec((err, Users) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , users:Users});
		});
	},

	ById: (req,res,next) => {
		UserModel.findById(req.params.object_id, (err,User) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , user:User});
		});
	},

	Update: (req,res,next) => {
		UserModel.findById(req.params.object_id, (err, User) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				if (User) {
					if(req.body.email) {
						User.name = req.body.name;
					}
					if(req.body.name) {
						User.name = req.body.name;
					}
					if(req.body.phone) {
						User.phone = req.body.phone;
					}
					if(req.body.address) {
						User.address = req.body.address;
					}
					if(req.body.rol) {
						User.rol = req.body.rol;
					}
					if(req.body.push_id) {
						User.push_id = req.body.push_id;
					}
					User.save((err, newUser) => {
						if(err){
							return next(new errs.InternalServerError(err));
						}
						return res.json({success: true , user: newUser, message:"Actualizado Exitosamente."});
					});
				} else {
					return next(new errs.BadRequestError("No existe el elemento a editar."));
				}
			}
		});
	},

	Delete: (req,res,next) => {
		UserModel.remove({_id: req.params.object_id}, (err,Usuario) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , message:"Borrado Exitosamente."});
		});
	}
}
