'use strict';

//  Module dependencies.
var restify = require('restify');
var corsMiddleware = require('restify-cors-middleware');
var errs = require('restify-errors');

const cors = corsMiddleware({
    preflightMaxAge: 5,
    origins: ['*'],
    allowHeaders: ['authorization'],
    methods: ['OPTIONS']
})

module.exports = function(server, logger) {

    server.use(restify.plugins.acceptParser(server.acceptable));
    server.use(restify.plugins.queryParser());
    server.use(restify.plugins.bodyParser());
    server.use(restify.plugins.fullResponse());

    server.pre(cors.preflight);
    server.use(cors.actual);

    // Let's log every incoming request. `req.log` is a "child" of our logger
    // with the following fields added by restify:
    // - a `req_id` UUID (to collate all log records for a particular request)
    // - a `route` (to identify which handler this was routed to)
    server.pre((req, res, next) => {
        logger.info({url: req.url, method: req.method}, 'Started');
        return next();
    });

    // Let's log every response. Except 404s, MethodNotAllowed,
    // VersionNotAllowed -- see restify's events for these.
    server.on('after', (req, res, route, error) => {
        logger.info( "Finished" );
    });

    server.on('MethodNotAllowed', function (req, res, route, error) {
        if (req.method.toLowerCase() === 'options') {

        var allowHeaders = ['accept', 'accept-version', 'Content-Type', 'api-version', 'request-id', 'origin', 'x-api-version', 'x-request-id', 'authorization'];

        if (res.methods.indexOf('OPTIONS') === -1) res.methods.push('OPTIONS');

            res.header('Access-Control-Allow-Credentials', true);
            res.header('Access-Control-Allow-Headers', allowHeaders.join(', '));
            res.header('Access-Control-Allow-Methods', res.methods.join(', '));
            res.header('Access-Control-Allow-Origin', req.headers.origin);

            logger.info( "Finished" );
            res.send(204);
        }else{
            logger.info( "Finished" );
            return res.send(new errs.MethodNotAllowedError('Method not allowed'));
        }
    });

};
