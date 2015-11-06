'use strict';

var express = require('express');
var app = express();
var bodyParser = require('body-parser');

var logger = require('morgan');

app.use(logger('combined'));
app.use(bodyParser.json());

app.get('/', function (request, response) {
  return response.status(200).end('Test');
});

app.use('/api/', require('routes'));

app.listen(8080);