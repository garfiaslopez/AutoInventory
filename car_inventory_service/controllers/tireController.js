//MODELS

var errs = require('restify-errors');
var objectModel = require("../models/tire");
var nameModel = {
	singular: 'tire',
	plural: 'tires'
};

module.exports = {

	Create: (req,res,next) => {
		var obj = new objectModel();
		obj.enterprise_id = req.body.enterprise_id;
		obj.brand = req.body.brand;
		if (req.body.size !== undefined) {
			obj.size = req.body.size;
		}
		if (req.body.season !== undefined) {
			obj.season = req.body.season;
		}
		if (req.body.stock !== undefined) {
			obj.stock = req.body.stock;
		}
		obj.save((err) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({ success: true , message: "Succesfully added.", _id: obj._id});
		});
	},


	All: (req,res,next) => {
		var Paginator = {
			page: 1,
			limit: 1000,
			sort: {
				created: -1, // desc
			}
		};

		// FOR PAGINATOR
		if (req.body.page != undefined) {
			Paginator.page = req.body.page;
		}
		if (req.body.limit != undefined) {
			Paginator.limit = req.body.limit;
		}


		// FOR FILTER
		var Filter = {
		}

		if (req.body.enterprise_id != undefined) {
			Filter['enterprise_id'] = req.body.enterprise_id
		}
		if (req.body.search_text != undefined) {
			Filter['$text'] = { '$search': req.body.search_text}
		}

		// FOR SORT
		if (req.body.sort_field != undefined) {
			Paginator.sort = {};
			Paginator.sort[req.body.sort_field] = -1;

			if (req.body.sort_order != undefined) {
				Paginator.sort[req.body.sort_field] = req.body.sort_order;
			}
		}
		objectModel.paginate(Filter, Paginator, (err, result) => {
			if(err) {
				return next(new errs.InternalServerError(err));
			} else {
				console.log(result);
				let response = {success: true };
				response[nameModel['plural']] = result;
				return res.json(response);
			}
		});
	},

	ById: (req,res,next) => {
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

	Update: (req,res,next) => {
		objectModel.findById( req.params.object_id, (err, obj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				if (obj) {
					if (req.body.enterprise_id !== undefined) {
						obj.enterprise_id = req.body.enterprise_id;
					}
					if (req.body.brand !== undefined) {
						obj.brand = req.body.brand;
					}
					if (req.body.size !== undefined) {
						obj.size = req.body.size;
					}
					if (req.body.season !== undefined) {
						obj.season = req.body.season;
					}
					if (req.body.stock !== undefined) {
						obj.stock = req.body.stock;
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

	Delete: (req,res,next) => {
		objectModel.remove({ _id: req.params.object_id }, (err, obj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			return res.json({success: true , message:"Succesfully deleted."});
		});
	}
}
