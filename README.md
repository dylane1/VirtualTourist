#  Virtual Tourist

This app allows the user to tap on a location on the map and see all the public Flickr images associated with that location.

## Important!
In order for this app to work, You must create a Keys.plist file and add your own Flickr API key to it. The plist needs to contain the a key called flickrKey and the value of the key needs to be a string. Below is an example
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>flickrKey</key>
        <string>[INSERT KEY HERE]</string>
    </dict>
</plist>
```
To obtain a Flickr API key, go here: https://www.flickr.com/services/api/misc.api_keys.html

