//MODELS

var errs = require('restify-errors');
var objectModel = require("../models/pending");
var ObjectId = require('mongoose').Types.ObjectId

var nameModel = {
	singular: 'pending',
	plural: 'pendings'
};

module.exports = {

	Create: (req,res,next) => {
		var obj = new objectModel();
		obj.denomination = req.body.denomination;
		obj.date = req.body.date;
		obj.enterprise_id = req.body.enterprise_id;
		obj.user_id = req.body.user_id;
		if (req.body.car_id !== undefined) {
			obj.car_id = req.body.car_id;
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

		Paginator.populate = 'car_id';

		// FOR FILTER
		var Filter = {
			is_done: false
		}

		if (req.body.enterprise_id != undefined) {
			Filter['enterprise_id'] = req.body.enterprise_id
		}
		if (req.body.is_done != undefined) {
			Filter['is_done'] = req.body.is_done;
		}
		if (req.body.initial_date != undefined) {
			if (req.body.final_date != undefined) {
				Filter['date'] = {
					'$gte': req.body.initial_date,
					'$lt': req.body.final_date
				};
			}
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
				let response = {success: true };
				response[nameModel['plural']] = result;
				return res.json(response);
			}
		});
	},

	AllWithAgg: (req,res,next) => {
		// FOR FILTER (QUERY)
		var Filter = {
			is_done: false
		}
		if (req.body.enterprise_id != undefined) {
			Filter['enterprise_id'] = ObjectId(req.body.enterprise_id);
		}
		if (req.body.is_done != undefined) {
			Filter['is_done'] = req.body.is_done;
		}

		var Aggs = [];
		var timezone = 'America/Edmonton';
		if (req.body.timezone != undefined) {
			timezone = req.body.timezone;
		}
		if (req.body.agg !== undefined) {
			Aggs.push({
		        '$project': {
		            yearMonthDay: {
						$dateToString: {
							format: "%Y-%m-%d",
							date: "$date"
						}
					},
					is_done: 1,
			        enterprise_id: 1
		        }
		    });
			Aggs.push({
				'$match': Filter
			});
			Aggs.push({
		        '$group': {
		            _id: {
						date: '$yearMonthDay'
					},
		            total: {
						'$sum': 1
					}
				}
		    });
		}

		objectModel.aggregate(Aggs, (err, result) => {
			if(err){
				return next(new errs.InternalServerError(err));
			} else {
				return res.json({ success: true , data: result});
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
			}
			if(req.body.denomination !== undefined) {
				obj.denomination = req.body.denomination;
			}
			if(req.body.date !== undefined){
				obj.date = req.body.date;
			}
			if(req.body.enterprise_id !== undefined){
				obj.enterprise_id = req.body.enterprise_id;
			}
			if(req.body.user_id !== undefined){
				obj.user_id = req.body.user_id;
			}
			if(req.body.is_done !== undefined){
				obj.is_done = req.body.is_done;
			}

			obj.save((err, newObj) => {
				if(err){
					return next(new errs.InternalServerError(err));
				}
				let response = {success: true , message:"Succesfully updated."};
				response[nameModel['singular']] = newObj;
				return res.json(response);
			});
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
