# ASJNetworking

Ever since getting the hang of making network requests and playing with JSON, it always felt cumbersome to me to deal with the code required to make them, especially POST requests. I found code samples online but could never settle upon anything, alternating between making spaghetti of my code by pasting code samples everywhere or using a third party solution. I wanted consistency for myself and I created this basic networking class built upon `NSURLSession` that fills all my simple needs.

`ASJNetworking` can make these kinds of HTTP requests:
* GET
* HEAD
* POST
* PUT
* PATCH
* DELETE

# Installation

CocoaPods is the preferred way to install this library. Add this command to your `Podfile`:

```ruby
pod 'ASJNetworking'
```

If you prefer the classic way, just copy the `ASJNetworking` folder (.h and .m files) to your project.

# Usage

Making requests is simple. You will first need to create an instance of `ASJNetworking` then call the appropriate method of the request you wish to make. There are methods provided for all kinds of HTTP requests. For example, if you wish to make a GET request: 

```objc
ASJNetworking *getRequest = [[ASJNetworking alloc] initWithBaseUrl:@"http://example.com"];
[getRequest GET:@"method_name" parameters:params completion:^(id response, NSString *responseString, NSError *error) {
  // handle response
}];
```

For a multipart POST method, you will need to pass an array of `ASJImageItems`. There is an optional progress block provided so that you can track the upload.

```objc
ASJImageItem *imageItem = [ASJImageItem imageItemWithName:@"image_name" fileName:@"image.jpg" image:[UIImage imageNamed:@"image"]];

ASJNetworking *postRequest = [[ASJNetworking alloc] initWithBaseUrl:@"http://example.com"];
[postRequest POST:@"method_name" parameters:params imageItems:@[anImageItem] progress:^(CGFloat progressPc) {
  // handle progress
} completion:^(id response, NSString *responseString, NSError *error) {
  // handle response
}];
```

# To-do

- ~~Test DELETE request.~~
- ~~Test HEAD request.~~
- ~~Check for nil values in image items.~~
- ~~Add network activity indicator support.~~
- ~~Add multipart to PUT request.~~
- How to send parameters in the header.
- How to make categories to set image on image view etc.
- Ability to make batch requests.

# Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) and its contributors.
- [Abhijit Kayande](https://github.com/Abhijit-Kayande) for *Ctrl+Cmd+Spc*.
- [Send POST request using NSURLSession](http://stackoverflow.com/a/19101084).
- [Is there any way to attach a NSDictionary of parameters to an NSURLRequest instead of manually making a string?](http://stackoverflow.com/a/32638248)
- [POST (HTTP): Wikipedia](https://en.wikipedia.org/wiki/POST_(HTTP))
- [RFC 7578: Returning Values from Forms: multipart/form-data](https://www.rfc-editor.org/rfc/rfc7578.txt)

# License

`ASJNetworking` is available under the MIT license. See the LICENSE file for more info.
