# slack-emoji-download.rb

This is a simple ruby script that allows you to download all of your custom slack emoji's to your local workstation using the Slack API.

#### Requirements
Slack API Key
- Part of slacks integrations, you can obtain an API key. This is needed to pull down the list of custom emoji's
- 
Ruby 1.9 or higher
RubyGems
- json
- optparse
- net/http

#### How to run this thing
You'll need to pass in the token via an arg to the script. You can also specify the directory to download the emoji's to, though it will default to your users Download directory if not supplied.

```bash
$ ruby slack-emoji-download.rb 
Usage: slack-emoji-download.rb [options]
    -t, --tokeni TOKEN               Slack API Token (Required)
    -d, --directory DIR_PATH         Download Directory (Default: Downloads)
```
