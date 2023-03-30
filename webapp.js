var http = require('http')
var body = "Appcharge!!!"

http.createServer(onRequest).listen(80);
console.log('Server has started\n');

function onRequest(request, response) {
  response.writeHead(200);
  response.write(body);
  response.end();
  console.log('Body: ', body);
  console.log('Code: ', response.statusCode);
  console.log();
}
