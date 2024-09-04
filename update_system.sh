#!/bin/bash
# Purpose: a script to update Homebrew installations, macOS, and perform system maintenance in one go

# Function to check for success or failure
check_status() {
  if [ $? -eq 0 ]; then
    echo -e "\033[1;32m[SUCCESS] $1\033[0m" # Green success message
  else
    echo -e "\033[1;31m[ERROR] $1\033[0m"   # Red error message
    exit 1
  fi
}

# Linebreak function for better visual output
linebreak() {
  echo "----------------------------------------"
}

# Start the update process
clear
echo -e "\033[1;34mStarting system updates and maintenance...\033[0m"
linebreak

# 1. Check disk space usage
echo -e "\033[1;36mChecking disk space usage...\033[0m"
df -h /
check_status "Disk space check completed"
linebreak

# 2. Update macOS Software
echo -e "\033[1;36mUpdating macOS system software...\033[0m"
sudo softwareupdate -i -a
check_status "macOS software update"
linebreak

# 3. Check for Homebrew installation (if brew is not installed, offer to install it)
if ! command -v brew &> /dev/null
then
  echo -e "\033[1;33mHomebrew not found. Do you want to install it? (y/n)\033[0m"
  read -r install_brew
  if [[ "$install_brew" == "y" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_status "Homebrew installation"
  else
    echo -e "\033[1;31mHomebrew is required for this script. Exiting.\033[0m"
    exit 1
  fi
fi
linebreak

# 4. Update Homebrew repositories
echo -e "\033[1;36mUpdating Homebrew repositories...\033[0m"
brew update
check_status "Homebrew update"
linebreak

# 5. Upgrade all installed Homebrew packages
echo -e "\033[1;36mUpgrading installed Homebrew packages...\033[0m"
brew upgrade
check_status "Homebrew upgrade"
linebreak

# 6. Upgrade Homebrew casks (for apps installed via brew cask)
echo -e "\033[1;36mUpgrading Homebrew casks...\033[0m"
brew upgrade --cask
check_status "Homebrew cask upgrade"
linebreak

# 7. Remove old versions of installed packages
echo -e "\033[1;36mCleaning up old Homebrew versions...\033[0m"
brew cleanup
check_status "Homebrew cleanup"
linebreak

# 8. Check battery health (for MacBooks)
if [[ $(system_profiler SPPowerDataType | grep "Condition:") ]]; then
  echo -e "\033[1;36mChecking battery health...\033[0m"
  system_profiler SPPowerDataType | grep "Condition:"
  check_status "Battery health check completed"
else
  echo -e "\033[1;33mBattery health check skipped (not a MacBook).\033[0m"
fi
linebreak

# 9. Clear clipboard history
echo -e "\033[1;36mClearing clipboard history...\033[0m"
pbcopy < /dev/null
check_status "Clipboard history cleared"
linebreak

# Completion message
echo -e "\033[1;32mAll updates and maintenance tasks are complete!\033[0m"
echo -e "\033[1;34mHave a great day, $(whoami)! Praise and thank God <3\033[0m"
linebreak
