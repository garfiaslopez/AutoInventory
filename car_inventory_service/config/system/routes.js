'use strict';

//  Module dependencies.

var fs = require('fs');
var walk;

module.exports = function(server) {

    // Load URLs
    var routes_path = __dirname + '/../../routes';

    walk = function(path) {
        fs.readdirSync(path).forEach(function(file) {
            var newPath = path + '/' + file;
            var stat = fs.statSync(newPath);
            if (stat.isFile()) {
                if (/(.*)\.(js$|coffee$)/.test(file)) {
                    require(newPath)( server );
                }
            } else if (stat.isDirectory() && file !== 'middlewares') {
                walk(newPath);
            }
        });
    };
    walk( routes_path );

};
