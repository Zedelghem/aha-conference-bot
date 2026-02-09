# aha-conference-bot
A macOS specific bot to notify about new events announced by the American Historical Association 

## Requirements
A bash version supporting the =() operator (or zsh, for instance) and the following common command-line tools (probably bundled with your OS):
- curl
- sed
- join
- cmp
- comm

and less common command-line tools that will probably require installing:
- [pup](https://github.com/ericchiang/pup) (for HTML parsing)
- [growlrrr](https://github.com/moltenbits/growlrrr)

## Setup

1. Put the script wherever you keep your scripts and make it executable. Download the logo as well, if you want to use it in your notifications.
2. Using growlrrr, define a minimalistic custom app pointing to your logo file: `grrr apps add --appId AHAConferenceBot --appIcon ./aha-logo.png`.
3. Give growlrrr and your new app permissions to send notifications in System Preferences.
4. Schedule regular runs of the script using launchctl (or cron if you have to). [Use this StackOverflow comment as a guide.](https://stackoverflow.com/a/78712464)

## The launchctl setup comment from StackOverflow:

```
# Source - https://stackoverflow.com/a/78712464
# Posted by ThatXliner
# Retrieved 2026-02-08, License - CC BY-SA 4.0
```

> The top answer is kind of old as launchctl load is marked as a legacy subcommand in favor of launchctl enable.
> The first 2 steps are the same: save the following as servicename.plist in ~/Library/LaunchAgents:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
          <key>Label</key>
          <string>servicename</string>
          <key>ProgramArguments</key>
          <array>
                  <string>osascript</string>
                  <string>-c</string>
                  <string>"set volume 1.7"</string>
          </array>
          <key>StartCalendarInterval</key>
          <dict>
                  <key>Hour</key>
                  <integer>23</integer>
                  <key>Minute</key>
                  <integer>45</integer>
          </dict>
  </dict>
  </plist>
  ```
> But to enable this, you must run launchctl enable user/502/servicename where 502 is your user UID. Run the following command to find out your user UID:

`echo "show State:/Users/ConsoleUser" | scutil | awk '/kCGSSessionUserIDKey :/ { print $3 }'`
