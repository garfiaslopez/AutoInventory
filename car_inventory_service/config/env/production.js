'use strict';
// SSH : HaQj4UKJpBBddS3N
module.exports = {
    port: 3100,
    app: {
        name: 'API - Production'
    },
    dbMongo: 'mongodb://InventoryApi:HaQj4UKJpBBddS3N@127.0.0.1:18509/Inventory',
	key: "HQR6E2lSA2LuWmxd5Akm"
};


/**

use admin
db.createUser(
  {
    user: "InventorySuperUser",
    pwd: "CLttFUZthSanAKvm",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

use GorilasApp
db.createUser(
    {
      user: "InventoryApi",
      pwd: "HaQj4UKJpBBddS3N",
      roles: [
         { role: "readWrite", db: "Inventory" }
      ]
    }
)



**/
