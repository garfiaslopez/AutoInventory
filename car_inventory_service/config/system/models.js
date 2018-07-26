'use strict';

//  Module dependencies.

var fs = require('fs');
var walk;

module.exports = function() {

    //  Load Models
    var models_path = __dirname + '/../../models';

    walk = function(path) {
        fs.readdirSync(path).forEach(function(file) {
            var newPath = path + '/' + file;
            var stat = fs.statSync(newPath);
            if (stat.isFile()) {
                if (/(.*)\.(js$|coffee$)/.test(file)) {
                    require(newPath);
                }
            } else if (stat.isDirectory()) {
                walk(newPath);
            }
        });
    };
    walk( models_path );

};