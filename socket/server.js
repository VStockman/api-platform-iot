const io = require('socket.io')();
const SerialPort = require('serialport');
const xbee_api = require('xbee-api');
const C = xbee_api.constants;
const request = require('request');
const xbeeAPI = new xbee_api.XBeeAPI({
  api_mode: 2
});

let availablePlaces = [1,2,3];
const serialport = new SerialPort("COM3", {
  baudRate: 9600,
}, function (err) {
  if (err) {
    return console.log('Error: ', err.message)
  }
});

serialport.pipe(xbeeAPI.parser);
xbeeAPI.builder.pipe(serialport);

serialport.on("open", function () {
  var frame_obj = { 
    type: C.FRAME_TYPE.AT_COMMAND,
    command: "NI",
    commandParameter: [],
  };

  xbeeAPI.builder.write(frame_obj);

  frame_obj = { // AT Request to be sent
    type: C.FRAME_TYPE.REMOTE_AT_COMMAND_REQUEST,
    destination64: "FFFFFFFFFFFFFFFF",
    command: "NI",
    commandParameter: [],
  };
});


xbeeAPI.parser.on("data", function (frame) {

  if (C.FRAME_TYPE.ZIGBEE_RECEIVE_PACKET === frame.type) {

    let dataReceived = String.fromCharCode.apply(null, frame.data);
    console.log(dataReceived);
    browserClient && browserClient.emit('pad-event', {
      device: frame.remote64,
      data: dataReceived
    });
  }

  if (C.FRAME_TYPE.NODE_IDENTIFICATION === frame.type) {

  } else if (C.FRAME_TYPE.ZIGBEE_IO_DATA_SAMPLE_RX === frame.type) {

  } else if (C.FRAME_TYPE.REMOTE_COMMAND_RESPONSE === frame.type) {

  } else {
    let dataReceived = String.fromCharCode.apply(null, frame.commandData);
    if(frame.data) {
      switch(frame.data[5]) {
        case 0:
          availablePlaces = [1,2,3];
          break;
        case 1 :
          availablePlaces = [2,3];
          break;
        case 2:
          availablePlaces = [1,3];
          break;
        case 3 :
          availablePlaces = [3];
          break;
        case 4:
          availablePlaces = [1,2];
          break;
        case 5 :
          availablePlaces = [2];
          break;
        case 6:
          availablePlaces = [1];
          break;
        case 7:
          availablePlaces = [];
          break;
      }
      console.log(availablePlaces);
      for (let i=1; i<4; i++) {
        let id;
        switch (i) {
          case 1 :
            id =3;
            break;
          case 2:
            id = 4;
            break;
          case 3:
            id = 5;
            break;
        }
        const url = 'https://192.168.99.100:8443/places/' + id;
        const body = JSON.stringify({
          "number": i,
          "available": availablePlaces.includes(i),
          "parking": "/parkings/1"
        });
        request(
          {
            rejectUnauthorized: false,
            uri: url,
            headers: {
              'Content-Type': 'application/json'
            },
            body : body,
            method: 'PUT'
          },
          (error, response, body) => {
            if (!error && response.statusCode === 200) {
              const data = JSON.parse(body);
            } else {
            }
          }
        );
      }
    }
  }

});
let browserClient;
io.on('connection', (client) => {
  console.log(client.client.id);
  browserClient = client;
  client.on('subscribeToPad', (interval) => {
    console.log('client is subscribing to timer with interval ', interval);
  });

  client.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

const port = 8000;
io.listen(port);
console.log('listening on port ', port);

