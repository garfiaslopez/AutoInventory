 'use strict';

//  Module dependencies.
var AccountFunctions = require("../controllers/accountController");
var UserFunctions = require("../controllers/userController");
var EnterpriseFunctions = require("../controllers/enterpriseController");
var CarFunctions = require("../controllers/carController");
var PendingFunctions = require("../controllers/pendingController");
var TireFunctions = require("../controllers/tireController");

var AuthenticateFunctions = require("../controllers/authController");
var MiddleAuth = require('./../middlewares/auth');

module.exports = function(server) {

    //  Redirect request to controller
    server.post('/authenticate',AuthenticateFunctions.AuthByUser);

    server.post('/account',AccountFunctions.Create);
    server.post('/user',UserFunctions.Create);


    //the routes put before the middleware does not is watched.
    server.use(MiddleAuth.isAuthenticated);

    server.get('/authenticate/me',AuthenticateFunctions.InfoUser);

    // ACCOUNT:
    server.post('/account',AccountFunctions.Create);

    server.put('/account/:object_id',AccountFunctions.Update);
    server.del('/account/:object_id',AccountFunctions.Delete);
    server.get('/account/:object_id',AccountFunctions.ById);
    server.get('/accounts',AccountFunctions.All);

    // ENTERPRISE
    server.post('/enterprise',EnterpriseFunctions.Create);
    server.put('/enterprise/:object_id',EnterpriseFunctions.Update);
    server.del('/enterprise/:object_id',EnterpriseFunctions.Delete);
    server.get('/enterprise/:object_id',EnterpriseFunctions.ById);
    server.get('/enterprises',EnterpriseFunctions.All);
    server.get('/enterprises/byaccount/:account_id',EnterpriseFunctions.AllByAccount);


    // USER
	server.get('/user/:object_id',UserFunctions.ById);
	server.put('/user/:object_id',UserFunctions.Update);
	server.del('/user/:object_id',UserFunctions.Delete);
    server.get('/users',UserFunctions.All);
    server.get('/users/byaccount/:account_id',UserFunctions.All);

    //PENDING CONTROLLER
    server.post('/pending',PendingFunctions.Create);
    server.get('/pending/:object_id',PendingFunctions.ById);
    server.put('/pending/:object_id',PendingFunctions.Update);
    server.del('/pending/:object_id',PendingFunctions.Delete);

    server.post('/pendings',PendingFunctions.All);
    server.post('/pendings/agg',PendingFunctions.AllWithAgg);


    //TIRE CONTROLLER
    server.post('/tire',TireFunctions.Create);
    server.get('/tire/:object_id',TireFunctions.ById);
    server.put('/tire/:object_id',TireFunctions.Update);
    server.del('/tire/:object_id',TireFunctions.Delete);

    server.post('/tires',TireFunctions.All);


    //CAR CONTROLLER
    server.post('/car',CarFunctions.Create);
    server.get('/car/:object_id',CarFunctions.ById);
    server.put('/car/:object_id',CarFunctions.Update);
    server.del('/car/:object_id',CarFunctions.Delete);

    server.post('/cars',CarFunctions.All);

};
