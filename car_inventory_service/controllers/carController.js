//MODELS

var errs = require('restify-errors');
var objectModel = require("../models/car");
var pendingModel = require("../models/pending");

var nameModel = {
	singular: 'car',
	plural: 'cars'
};

module.exports = {

	Create: (req,res,next) => {
		var obj = new objectModel();
		obj.enterprise_id = req.body.enterprise_id;

		if (req.body.year !== undefined) {
			obj.year = Number(req.body.year);
			obj.year_text = String(req.body.year);
		}
		if (req.body.make !== undefined) {
			obj.make = req.body.make;
		}
		if (req.body.model !== undefined) {
			obj.model = req.body.model;
		}
		if (req.body.color !== undefined) {
			obj.color = req.body.color;
		}
		if (req.body.color_interior !== undefined) {
			obj.color_interior = req.body.color_interior;
		}
		if (req.body.vin !== undefined) {
			obj.vin = req.body.vin;
		}
		if (req.body.kilometers !== undefined) {
			obj.kilometers = Number(req.body.kilometers);
		}
		if (req.body.transmission !== undefined) {
			obj.transmission = req.body.transmission;
		}
		if (req.body.drive_train !== undefined) {
			obj.drive_train = req.body.drive_train;
		}
		if (req.body.opidi !== undefined) {
			obj.opidi = req.body.opidi;
		}
		if (req.body.opidi_done !== undefined) {
			obj.opidi_done = req.body.opidi_done;
		}
		if (req.body.price !== undefined) {
			obj.price = req.body.price;
		}
		if (req.body.arrival !== undefined) {
			obj.arrival = req.body.arrival;
		}
		if (req.body.delivery !== undefined) {
			obj.delivery = req.body.delivery;
		}
		if (req.body.advertising !== undefined) {
			obj.advertising = req.body.advertising;
		}
		if (req.body.pictures_taken !== undefined) {
			obj.pictures_taken = req.body.pictures_taken;
		}
		if (req.body.detailing_done !== undefined) {
			obj.detailing_done = req.body.detailing_done;
		}



		if (req.body.front_brakes !== undefined) {
			obj.front_brakes = Number(req.body.front_brakes);
		}
		if (req.body.rear_brakes !== undefined) {
			obj.rear_brakes = Number(req.body.rear_brakes);
		}
		if (req.body.front_rotors !== undefined) {
			obj.front_rotors = req.body.front_rotors;
		}
		if (req.body.rear_rotors !== undefined) {
			obj.rear_rotors = req.body.rear_rotors;
		}
		if (req.body.leaks !== undefined) {
			obj.leaks = req.body.leaks;
		}
		if (req.body.engine_oil !== undefined) {
			obj.engine_oil = req.body.engine_oil;
		}
		if (req.body.coolant !== undefined) {
			obj.coolant = req.body.coolant;
		}
		if (req.body.air_con !== undefined) {
			obj.air_con = req.body.air_con;
		}
		if (req.body.air_heat !== undefined) {
			obj.air_heat = req.body.air_heat;
		}
		if (req.body.dash_lights !== undefined) {
			obj.dash_lights = req.body.dash_lights;
		}


		if (req.body.scratches !== undefined) {
			obj.scratches = req.body.scratches;
		}
		if (req.body.dent !== undefined) {
			obj.dent = req.body.dent;
		}
		if (req.body.lights !== undefined) {
			obj.lights = req.body.lights;
		}
		if (req.body.wheels !== undefined) {
			obj.wheels = req.body.wheels;
		}

		if (req.body.is_delivery !== undefined) {
			obj.is_delivery = req.body.is_delivery;
		}

		if (req.body.tire_size !== undefined) {
			obj.tire_size = req.body.tire_size;
		}

		if (req.body.notes !== undefined) {
			obj.notes = req.body.notes;
		}

		obj.save((err, newObj) => {
			if(err){
				return next(new errs.InternalServerError(err));
			}
			// if the user create with delivery date, you need to create a reminder.
			if (newObj.delivery !== undefined) {
				var newPending = new pendingModel();
				newPending.denomination = 'Deliver car';
				newPending.date = obj.delivery;
				newPending.enterprise_id = obj.enterprise_id;
				newPending.car_id = newObj._id;
				newPending.save((err) => {
					return res.json({ success: true , message: "Succesfully added.", _id: obj._id});
				});
			} else {
				return res.json({ success: true , message: "Succesfully added.", _id: obj._id});
			}


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
			is_delivery: false
		}

		if (req.body.enterprise_id != undefined) {
			Filter['enterprise_id'] = req.body.enterprise_id
		}
		if (req.body.is_delivery != undefined) {
			Filter['is_delivery'] = req.body.is_delivery;
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

	ById: (req,res,next) => {
		objectModel.findById(req.params.object_id, (err, obj) => {
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

					if (req.body.year !== undefined) {
						obj.year = Number(req.body.year);
					}
					if (req.body.make !== undefined) {
						obj.make = req.body.make;
					}
					if (req.body.model !== undefined) {
						obj.model = req.body.model;
					}
					if (req.body.color !== undefined) {
						obj.color = req.body.color;
					}
					if (req.body.color_interior !== undefined) {
						obj.color_interior = req.body.color_interior;
					}
					if (req.body.vin !== undefined) {
						obj.vin = req.body.vin;
					}
					if (req.body.kilometers !== undefined) {
						obj.kilometers = Number(req.body.kilometers);
					}
					if (req.body.transmission !== undefined) {
						obj.transmission = req.body.transmission;
					}
					if (req.body.drive_train !== undefined) {
						obj.drive_train = req.body.drive_train;
					}
					if (req.body.opidi !== undefined) {
						obj.opidi = req.body.opidi;
					}
					if (req.body.opidi_done !== undefined) {
						obj.opidi_done = req.body.opidi_done;
					}
					if (req.body.price !== undefined) {
						obj.price = req.body.price;
					}
					if (req.body.arrival !== undefined) {
						obj.arrival = req.body.arrival;
					}
					if (req.body.delivery !== undefined) {
						obj.delivery = req.body.delivery;
					}
					if (req.body.advertising !== undefined) {
						obj.advertising = req.body.advertising;
					}
					if (req.body.pictures_taken !== undefined) {
						obj.pictures_taken = req.body.pictures_taken;
					}
					if (req.body.detailing_done !== undefined) {
						obj.detailing_done = req.body.detailing_done;
					}

					if (req.body.front_brakes !== undefined) {
						obj.front_brakes = Number(req.body.front_brakes);
					}
					if (req.body.rear_brakes !== undefined) {
						obj.rear_brakes = Number(req.body.rear_brakes);
					}
					if (req.body.front_rotors !== undefined) {
						obj.front_rotors = req.body.front_rotors;
					}
					if (req.body.rear_rotors !== undefined) {
						obj.rear_rotors = req.body.rear_rotors;
					}
					if (req.body.leaks !== undefined) {
						obj.leaks = req.body.leaks;
					}
					if (req.body.engine_oil !== undefined) {
						obj.engine_oil = req.body.engine_oil;
					}
					if (req.body.coolant !== undefined) {
						obj.coolant = req.body.coolant;
					}
					if (req.body.air_con !== undefined) {
						obj.air_con = req.body.air_con;
					}
					if (req.body.air_heat !== undefined) {
						obj.air_heat = req.body.air_heat;
					}
					if (req.body.dash_lights !== undefined) {
						obj.dash_lights = req.body.dash_lights;
					}


					if (req.body.scratches !== undefined) {
						obj.scratches = req.body.scratches;
					}
					if (req.body.dent !== undefined) {
						obj.dent = req.body.dent;
					}
					if (req.body.lights !== undefined) {
						obj.lights = req.body.lights;
					}
					if (req.body.wheels !== undefined) {
						obj.wheels = req.body.wheels;
					}

					if (req.body.is_delivery !== undefined) {
						obj.is_delivery = req.body.is_delivery;
					}

					if (req.body.tire_size !== undefined) {
						obj.tire_size = req.body.tire_size;
					}

					if (req.body.notes !== undefined) {
						obj.notes = req.body.notes;
					}

					obj.save((err, newObj) => {
						if(err){
							return next(new errs.InternalServerError(err));
						}
						// if update or especify the date of delivery, you need to change it or create it.
						if (newObj.delivery !== undefined) {
							pendingModel.find({ car_id: newObj._id }, (err, objPending) => {
								if(!err){
									if (objPending.length > 0) {
										objPending[0].date = newObj.delivery;
										objPending[0].save((err) => {
											let response = {success: true , message:"Succesfully updated."};
											response[nameModel['singular']] = newObj;
											return res.json(response);
										});
									} else {
										// reminder doesnt exists, create new one.
										var newPending = new pendingModel();
										newPending.denomination = 'Deliver car';
										newPending.date = obj.delivery;
										newPending.enterprise_id = obj.enterprise_id;
										newPending.car_id = newObj._id;
										newPending.save((err) => {
											let response = {success: true , message:"Succesfully updated."};
											response[nameModel['singular']] = newObj;
											return res.json(response);
										});
									}
								} else {
									let response = {success: true , message:"Succesfully updated."};
									response[nameModel['singular']] = newObj;
									return res.json(response);
								}
							});
						} else {
							let response = {success: true , message:"Succesfully updated."};
							response[nameModel['singular']] = newObj;
							return res.json(response);
						}

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
