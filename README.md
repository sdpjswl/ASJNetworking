# NetworkingHelper
A simple wrapper around AFNetworking to send GET and POST requests

Dependencies:
- [AFNetworking](https://github.com/AFNetworking/AFNetworking)
- [AFNetworkActivityLogger](https://github.com/AFNetworking/AFNetworkActivityLogger)
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

Parameters:
- "name"
e.g.: http://192.168.1.1/myPostRequest
"myPostRequest" is the name

- "params"
a dictionary containing key-value pairs. keys will be case sensitive depending on server code

- "images"
if constructing a multi-part request for uploading images, pass an array of UIImages

- "sender"
always 'self'. this will get a reference to the UIViewController to show the spinner on

- "completionBlock"
server response will be received in the block

Tips:
- You may enable or disable networking log messages by changing the const in the 'm' file
- You should set your server address before making any requests
- A spinner will automatically be shown, then hidden as requests start and complete/fail
