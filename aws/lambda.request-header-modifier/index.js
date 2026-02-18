'use strict';
exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const headers = request.headers;

  headers['accept-encoding'] = [
    {
      key: 'Accept-Encoding',
      value: 'gzip',
    },
  ];
  headers['content-encoding'] = [
    {
      key: 'Content-Encoding',
      value: 'gzip',
    },
  ];

  callback(null, request);
};
