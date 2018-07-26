var socketio = require('socket.io')();
var UserModel = require("./models/user");
var request = require('request');

var ConnectedIpads = [];
var ConnectedAdmins = [];


function ConnectIpad(NewUser){
	//añadir al arreglo
	if(ConnectedIpads.indexOf(NewUser) == -1){
		ConnectedIpads.push(NewUser);
		NewUser.socket.join('Ipads');
		console.log("connecting - Ipad");
	}
	LavadoModel.findById(NewUser.info.carwash_id).populate('users').exec(function(err, Lavado) {
		Lavado.status = true;
		Lavado.save();
		//send push notification for admins:
		// const msg = 'En linea autolavado: ' + Lavado.info.name;
		// Lavado.users.forEach(function(UserOfLavado){
		// 	if(UserOfLavado.rol === "Administrador"){
		// 		SendPNToAdmins(UserOfLavado.push_id, {body: msg, customData:{}}, function(data){
		// 			console.log("Sended Push");
		// 		});
		// 	}
		// });
	});
}

function RemoveIpad(NewUser){
	console.log("disconnecting - Ipad");
	var i = ConnectedIpads.indexOf(NewUser);
	ConnectedIpads.splice(i, 1);
	NewUser.socket.leave('Ipads');

	LavadoModel.findById(NewUser.info.carwash_id).populate('users').exec(function(err, Lavado) {
		Lavado.status = false;
		Lavado.save();
		//send push notification for admins:
		// const msg = 'Fuera de linea autolavado: ' + Lavado.info.name;
		// Lavado.users.forEach(function(UserOfLavado){
		// 	if(UserOfLavado.rol === "Administrador"){
		// 		SendPNToAdmins(UserOfLavado.push_id, {body: msg, customData:{}}, function(data){
		// 			console.log("Sended Push");
		// 		});
		// 	}
		// });
	});

}

function ConnectAdmin(NewUser){
	//añadir al arreglo
	if(ConnectedAdmins.indexOf(NewUser) == -1){
		ConnectedAdmins.push(NewUser);
		NewUser.socket.join('Admins');
		console.log("connecting - Admin");
	}
}

function RemoveAdmin(NewUser){
	console.log("disconnecting - Admin");
	var i = ConnectedAdmins.indexOf(NewUser);
	ConnectedAdmins.splice(i, 1);
	NewUser.socket.leave('Admins');
}

function SendPNToAdmins(push_id,message,callback){
	var UrlToPush = "https://go.urbanairship.com/api/push";
	var Notification = {
		audience: {
			OR: [
				{ ios_channel:  push_id },
			]
		},
		notification: {
			ios: {
				alert: message.body,
				extra: message.customData,
				sound: "default"
			}
		},
    	device_types: "all"
	}
	var Headers = {
		'Accept': 'application/vnd.urbanairship+json; version=3',
		'Content-Type': 'application/json'
	}
	var Auth = {
		'user': 'tORkL5IUT5yp47ymVhufcQ',
		'pass': 'HOBenatRRnqJkNUu9u-5ZA'
	}
	request({method: 'POST', uri: UrlToPush, headers: Headers, auth: Auth, body: JSON.stringify(Notification) } , function(error, response, body) {
		if (error) {
			callback(null);
		}
    	callback(body);
	});
}


exports.initialize = function(server){

	var io = socketio.listen(server);

	io.on('connection', function (MainSocket) {

		console.log('OnConnection');
		MainSocket.emit('HowYouAre');
		/////// CONNECTION HANDLER FUNCTIONS   /////////////
		MainSocket.on('ConnectedIpad', function (data) {
			if(data.user_id != ''){
				var NewUser = { info: data, socket: MainSocket, available: true };
				ConnectIpad(NewUser);
				MainSocket.on('disconnect', function() {
					RemoveIpad(NewUser);
				});
			}else{

			}
		});
		MainSocket.on('ConnectedAdmin', function (data) {
			if(data.user_id != ''){
				var NewAdmin = { info: data, socket: MainSocket, available: true  };
				ConnectAdmin(NewAdmin);
				MainSocket.on('disconnect', function() {
					RemoveAdmin(NewAdmin);
				});
			}
		});

		//From IPAD APP... IF SUCCESS SAVE TICKET ACTIVO.
		MainSocket.on('RefreshActiveTickets', function (data) {
				//enviar una notificacion a los administradores para que refresquen los tickets activos.
				ConnectedAdmins.forEach(function(Admin){
					Admin.socket.emit("refreshActiveTickets",data);
				});
		});

		//From IPAD APP... IF SUCCESS SAVE TICKET ACTIVO.
		MainSocket.on('RefreshDashboard', function (data) {
				//enviar una notificacion a los administradores para que refresquen los tickets activos.
				ConnectedAdmins.forEach(function(Admin){
					Admin.socket.emit("refreshDashboard",data);
				});

		});

		//From IPAD APP...
		MainSocket.on('PendingAdded', function (data) {
				//enviar una notificacion a los administradores para que refresquen los tickets activos.
				LavadoModel.findById(data.carwash_id).populate('users').exec(function(err, Lavado) {
					//send push notification for admins:
					const msg = data.carwash_name + ': ' + data.denomination;
					Lavado.users.forEach(function(UserOfLavado){
						if(UserOfLavado.rol === "Administrador"){
							SendPNToAdmins(UserOfLavado.push_id, {body: msg, customData:{}}, function(data){
								console.log("Sended Push");
							});
						}
					});
				});
		});

		MainSocket.on('SendMessage', function (data) {
			if (data.carwash_id == "EVERYONE"){
				MainSocket.emit('MessageToIpad', {title: data.title , message: data.message});
			}else {
				ConnectedIpads.forEach(function(Ipad){
					if(Ipad.info.carwash_id == data.carwash_id){
						var dataToSend = {
							title: data.title,
							message: data.message
						}
						Ipad.socket.emit("MessageToIpad", dataToSend);
					}
				});
			}
		});
	});
}
