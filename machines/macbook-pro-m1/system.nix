{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}:
{

  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true; # show full name in login window
      };
    };
    menuExtraClock.Show24Hour = true; # show 24 hour clock

    NSGlobalDomain = {
      # Global macOS system settings
      KeyRepeat = 1;

      AppleShowAllExtensions = true;
      _HIHideMenuBar = true;

      NSAutomaticCapitalizationEnabled = false; # disable auto capitalization(自动大写)
      NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution(智能破折号替换)
      NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution(智能句号替换)
      NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution(智能引号替换)
      NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction(自动拼写检查)
      NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default(保存文件时的路径选择/文件名输入页)
      NSNavPanelExpandedStateForSaveMode2 = true;

    };
    CustomSystemPreferences = {
      NSGlobalDomain.AppleSpacesSwitchOnActivate = false;
    };
    dock = {
      autohide = true; # automatically hide and show the dock
      show-recents = false; # do not show recent apps in dock
      # do not automatically rearrange spaces based on most recent use.
      mru-spaces = false;

      # customize Hot Corners(触发角, 鼠标移动到屏幕角落时触发的动作)
      wvous-tl-corner = 2; # top-left - Mission Control
      wvous-tr-corner = 13; # top-right - Lock Screen
      wvous-bl-corner = 3; # bottom-left - Application Windows
      wvous-br-corner = 4; # bottom-right - Desktop

      orientation = "bottom";
      showhidden = true;
      tilesize = 40;
      appswitcher-all-displays = true;
    };
    finder = {
      _FXShowPosixPathInTitle = true; # show full path in finder title
      AppleShowAllExtensions = true; # show all file extensions
      FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
      QuitMenuItem = true; # enable quit menu item
      ShowPathbar = true; # show path bar
      ShowStatusBar = true; # show status bar
    };
    trackpad = {
      # tap - 轻触触摸板, click - 点击触摸板
      Clicking = true; # enable tap to click(轻触触摸板相当于点击)
      TrackpadRightClick = true; # enable two finger right click
      TrackpadThreeFingerDrag = true; # enable three finger drag
    };
  };

  keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  # activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish'' ;
  stateVersion = 4;
};

}
