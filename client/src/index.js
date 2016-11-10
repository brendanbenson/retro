'use strict';

require('!style!css!sass!./style/styles.scss');

require('./index.html');


var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');
var serverUrl;

if (document.location.host.indexOf('localhost') > -1) {
    serverUrl = 'http://localhost:8080';
} else {
    serverUrl = 'https://retroapp.cfapps.io:4443';
}


var app = Elm.Main.embed(mountNode, {
    host: document.location.host,
    serverUrl: serverUrl
});

require('../node_modules/stompjs/lib/stomp.js');

var SockJS = require('../node_modules/sockjs-client/lib/entry.js'),
    socket,
    stompClient,
    subscribedChannel;

app.ports.connectWebSocket.subscribe(function (channel) {
    subscribedChannel = channel;
    socket = new SockJS(serverUrl + '/chat');
    if (stompClient) {
        stompClient.disconnect();
    }
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function (frame) {
        stompClient.subscribe('/topic/' + channel, function (messageOutput) {
            app.ports.receiveMessage.send(JSON.parse(messageOutput.body));
        });
    });
});

app.ports.addRetroItem.subscribe(function (message) {
    stompClient.send('/app/chat/' + subscribedChannel, {}, JSON.stringify(message));
});

app.ports.markRetroItemDone.subscribe(function (retroItemId) {
    stompClient.send('/app/chat/' + subscribedChannel + '/items/' + retroItemId + '/finish', {}, '');
});

app.ports.markRetroItemUndone.subscribe(function (retroItemId) {
    stompClient.send('/app/chat/' + subscribedChannel + '/items/' + retroItemId + '/unfinish', {}, '');
});
