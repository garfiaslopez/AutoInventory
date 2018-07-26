//MODELS
var errs = require('restify-errors');
var AccountModel = require("../models/account");

module.exports = {
	Create: (req,res,next) => {
		if (req.body.denomination) {
			var Account = new AccountModel();
	        Account.denomination = req.body.denomination;
			// TODO: Add another data.
	        Account.save((err, newAccount) => {
	            if(err){
	                if(err.code == 11000){
	                    return next(new errs.BadRequestError("Entrada duplicada"));
	                }else{
	                    return next(new errs.InternalServerError(err));
	                }
	            } else {
	                return res.json({success: true , account: newAccount, message:"Creado Existosamente."});
	            }
	        });
		} else {
			return next(new errs.BadRequestError("Faltan parametros"));
		}
	},

	All: (req,res,next) => {
		AccountModel.find((err, Accounts) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , accounts:Accounts});
		});
	},

	ById: (req,res,next) => {
		AccountModel.findById(req.params.object_id, (err,Account) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , account: Account});
		});
	},

	Update: (req,res,next) => {
		AccountModel.findById(req.params.object_id, (err, Account) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			if(req.body.denomination){
				Account.denomination = req.body.denomination;
			}
			// TODO: Add another data.

			Account.save((err, newAccount) => {
				if(err){
					return next(new errs.InternalServerError(err));
				}
				return res.json({success: true , account: newAccount, message: "Actualizado correctamente"});
			});
		});
	},

	Delete: (req,res,next) => {
		AccountModel.remove({_id: req.params.object_id }, (err, Account) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , account: Account, message:"Borrado correctamente"});
		});
	}
}
