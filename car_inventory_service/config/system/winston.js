var winston = require('winston');
var moment = require('moment');

// Create a Winston logger
// Only terminal
exports.logger = new (winston.Logger)({
    transports: [
        new (winston.transports.Console)(
            {
                colorize: true,
                timestamp: function(){
                    var date = moment( new Date() ).format('YYYY-MM-DD HH:mm:ss');
                    return date;
                }
            }
        )
    ]
});
