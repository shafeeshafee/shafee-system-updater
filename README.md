# Shafee's simple macOS updater

This is my personal updater script automates system maintenance tasks for macOS, including:

- Checking disk space usage
- Updating macOS software
- Managing Homebrew packages and casks
- Checking battery health (for MacBook users)
- Clearing clipboard history

## Usage

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/macos-maintenance-script.git
   ```

2. Run the script:

   ```bash
   ./update_system.sh
   ```

   You may need to provide your `sudo` password during macOS updates and system management tasks.

## Automating the Script with Launchd (Recommended for macOS)

For automating this script at regular intervals, use `launchd`, which is macOS's native scheduling system. While `cron` can also be used, `launchd` is better integrated with macOS and preferred for reliability.

### Using `launchd` (Recommended)

1. Create a `plist` file in `~/Library/LaunchAgents`:

   ```bash
   nano ~/Library/LaunchAgents/com.yourusername.updatescript.plist
   ```

2. Add the following content, replacing `/path/to/your/update_system.sh` with the full path to your script:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
     <dict>
       <key>Label</key>
       <string>com.yourusername.updatescript</string>
       <key>ProgramArguments</key>
       <array>
         <string>/path/to/your/update_system.sh</string>
       </array>
       <key>StartCalendarInterval</key>
       <dict>
         <key>Hour</key>
         <integer>2</integer>
         <key>Minute</key>
         <integer>0</integer>
       </dict>
       <key>StandardOutPath</key>
       <string>/path/to/logfile.log</string>
       <key>StandardErrorPath</key>
       <string>/path/to/error.log</string>
       <key>RunAtLoad</key>
       <true/>
     </dict>
   </plist>
   ```

3. Load the `plist` file to activate the automation:

   ```bash
   launchctl load ~/Library/LaunchAgents/com.yourusername.updatescript.plist
   ```

4. To verify it is running:

   ```bash
   launchctl list | grep com.yourusername.updatescript
   ```

5. To unload the job (if you no longer want it to run automatically):
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.yourusername.updatescript.plist
   ```

### Using `cron` (Alternative)

Although `launchd` is the recommended option for macOS, you can also use `cron` to schedule the script.

1. Open your `cron` editor:
   ```bash
   crontab -e
   ```
2. Add the following line to run the script daily at 2:00 AM:
   ```bash
   0 2 * * * /path/to/your/update_system.sh >> /path/to/logfile.log 2>&1
   ```

Replace `/path/to/your/update_system.sh` with the full path to your script.

## (Optional) Create an alias for it

If you don't want to automate it and use it as a one-off type command wherever you are in your terminal, you can do so simply by adding it to your shell configuration file, e.g., `.zshrc`.

1. Make the script executable:
   ```bash
   chmod +x ~/path/to/your/update_system.sh
   ```

2. Open your shell configuration file:
   ```bash
   nano ~/.zshrc
   ```

3. Add the alias, for example `updatesys`:
   ```bash
   alias updatesys='~/path/to/your/update_system.sh'
   ```

4. Save and exit the file.

5. Reload your shell configuration to apply the changes:
   ```bash
   source ~/.zshrc
   ```

Now you can run the script anytime by simply typing `updatesys` in the terminal.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
