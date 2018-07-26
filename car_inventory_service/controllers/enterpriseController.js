//MODELS

var errs = require('restify-errors');
var objectModel = require("../models/enterprise");
var nameModel = {
	singular: 'enterprise',
	plural: 'enterprises'
};

module.exports = {

	Create: (req,res) => {
		var obj = new objectModel();
		obj.account_id = req.body.account_id;
		obj.denomination = req.body.denomination;

		if (req.body.phone !== undefined) {
			obj.phone = req.body.phone;
		}
		if (req.body.address !== undefined) {
			obj.address = req.body.address;
		}
		obj.save((err) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({ success: true , message: "Succesfully added.", _id: obj._id});
		});
	},


	All: (req,res) => {
		var Paginator = {
			page: 1,
			limit: 10
		};
		objectModel.paginate({}, Paginator, (err, result) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				let response = {success: true };
				response[nameModel['plural']] = result;
				return res.json(response);
			}
		});
	},

	AllByAccount: (req,res) => {
		var Paginator = {
			page: 1,
			limit: 10
		};
		objectModel.paginate({ account_id: req.params.account_id } , Paginator, (err, result) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				let response = {success: true };
				response[nameModel['plural']] = result;
				return res.json(response);
			}
		});
	},
	ById: (req,res) => {
		objectModel.findById( req.params.object_id, (err, obj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				if (obj) {
					let response = {success: true };
					response[nameModel['singular']] = obj;
					return res.json(response);
				} else {
					return next(new errs.BadRequestError("Element doesn't exists."));
				}
			}
		});
	},

	Update: (req,res) => {
		objectModel.findById( req.params.object_id, (err, obj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				if (obj) {
					obj.account_id = req.body.account_id;
					obj.denomination = req.body.denomination;

					if (req.body.phone !== undefined) {
						obj.phone = req.body.phone;
					}
					if (req.body.address !== undefined) {
						obj.address = req.body.address;
					}
					obj.save((err) => {
						if(err){
							return next(new errs.InternalServerError(err));
						}
						return res.json({success: true , message:"Succesfully updated."});
					});
				} else {
					return next(new errs.BadRequestError("Element doesn't exists."));
				}
			}
		});
	},

	Delete: (req,res) => {
		objectModel.remove({ _id: req.params.object_id }, (err, obj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , message:"Succesfully deleted."});
		});
	}
}
