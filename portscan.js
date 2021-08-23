var portscanner = require('portscanner'); 

var myargs = process.argv.slice(2);

var myhost = myargs[0];
var myport = parseInt(myargs[1]);
portscanner.checkPortStatus(myport, myhost).then(status => { console.log(status) });
