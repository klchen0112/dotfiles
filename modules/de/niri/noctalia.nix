{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.nixos.noctalia-shell = {
    imports = [
      inputs.noctalia-shell.nixosModules.default
    ];
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.noctalia-shell.enable = true;
  };
  flake.modules.homeManager.noctalia-shell =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.noctalia-shell.homeModules.default

      ];

      programs.niri = {
        settings = {
          # ...
          binds = with config.lib.niri.actions; {
            "Mod+Space".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "launcher"
              "toggle" # ✅

            ];
            "Mod+P".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "sessionMenu"
              "toggle" # ❌
            ];
          };
        };
      };

      programs.noctalia-shell = {
        enable = true;
        package = null;
        settings = {
          setupCompleted = false;
          bar = {
            position = "right";
            monitors = [ ];
            density = "compact";
            showCapsule = true;
            floating = false;
            marginVertical = 0.25;
            marginHorizontal = 0.25;
            outerCorners = true;
            exclusive = true;
            widgets = {
              left = [
                {
                  id = "SystemMonitor";
                }
                {
                  id = "ActiveWindow";
                }
                {
                  id = "MediaMini";
                }
              ];
              center = [
                {
                  id = "Workspace";
                }
              ];
              right = [
                {
                  id = "ScreenRecorder";
                }
                {
                  id = "Tray";
                }
                {
                  id = "NotificationHistory";
                }
                {
                  id = "Battery";
                }
                {
                  id = "Volume";
                }
                {
                  id = "Brightness";
                }
                {
                  id = "Clock";
                }
                {
                  id = "ControlCenter";
                }
              ];
            };
          };
          general = {
            avatarImage = "";
            dimDesktop = true;
            showScreenCorners = false;
            forceBlackScreenCorners = false;
            scaleRatio = 1;
            radiusRatio = 1;
            screenRadiusRatio = 1;
            animationSpeed = 1;
            animationDisabled = false;
            compactLockScreen = false;
            lockOnSuspend = true;
            enableShadows = true;
            shadowDirection = "bottom_right";
            shadowOffsetX = 2;
            shadowOffsetY = 3;
            language = "";
          };
          ui = {
            fontDefaultScale = 1;
            fontFixedScale = 1;
            tooltipsEnabled = true;
            panelsAttachedToBar = true;
            panelsOverlayLayer = false;
          };
          location = {
            name = "Shanghai";
            weatherEnabled = true;
            useFahrenheit = false;
            use12hourFormat = false;
            showWeekNumberInCalendar = false;
            showCalendarEvents = true;
            showCalendarWeather = true;
            analogClockInCalendar = false;
            firstDayOfWeek = -1;
          };
          screenRecorder = {
            directory = "";
            frameRate = 60;
            audioCodec = "opus";
            videoCodec = "h264";
            quality = "very_high";
            colorRange = "limited";
            showCursor = true;
            audioSource = "default_output";
            videoSource = "portal";
          };
          wallpaper = {
            enabled = true;
            overviewEnabled = true;
            directory = "";
            enableMultiMonitorDirectories = false;
            recursiveSearch = false;
            setWallpaperOnAllMonitors = true;
            defaultWallpaper = "";
            fillMode = "crop";
            fillColor = "#000000";
            randomEnabled = false;
            randomIntervalSec = 300;
            transitionDuration = 1500;
            transitionType = "random";
            transitionEdgeSmoothness = 0.05;
            monitors = [ ];
            panelPosition = "follow_bar";
          };
          appLauncher = {
            enableClipboardHistory = false;
            position = "center";
            pinnedExecs = [ ];
            useApp2Unit = false;
            sortByMostUsed = true;
            terminalCommand = "xterm -e";
            customLaunchPrefixEnabled = false;
            customLaunchPrefix = "";
          };
          controlCenter = {
            position = "close_to_bar_button";
            shortcuts = {
              left = [
                {
                  id = "WiFi";
                }
                {
                  id = "Bluetooth";
                }
                {
                  id = "ScreenRecorder";
                }
                {
                  id = "WallpaperSelector";
                }
              ];
              right = [
                {
                  id = "Notifications";
                }
                {
                  id = "PowerProfile";
                }
                {
                  id = "KeepAwake";
                }
                {
                  id = "NightLight";
                }
              ];
            };
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = true;
                id = "shortcuts-card";
              }
              {
                enabled = true;
                id = "audio-card";
              }
              {
                enabled = true;
                id = "weather-card";
              }
              {
                enabled = true;
                id = "media-sysmon-card";
              }
            ];
          };
          dock = {
            enabled = true;
            displayMode = "auto_hide";
            floatingRatio = 1;
            size = 1;
            onlySameOutput = true;
            monitors = [ ];
            pinnedApps = [ ];
            colorizeIcons = false;
          };
          network = {
            wifiEnabled = true;
          };
          notifications = {
            doNotDisturb = false;
            monitors = [ ];
            location = "top_right";
            overlayLayer = true;
            respectExpireTimeout = false;
            lowUrgencyDuration = 3;
            normalUrgencyDuration = 8;
            criticalUrgencyDuration = 15;
          };
          osd = {
            enabled = true;
            location = "top_right";
            monitors = [ ];
            autoHideMs = 2000;
            overlayLayer = true;
          };
          audio = {
            volumeStep = 5;
            volumeOverdrive = false;
            cavaFrameRate = 60;
            visualizerType = "linear";
            mprisBlacklist = [ ];
            preferredPlayer = "";
          };
          brightness = {
            brightnessStep = 5;
            enforceMinimum = true;
            enableDdcSupport = false;
          };
          colorSchemes = {
            useWallpaperColors = false;
            predefinedScheme = "Noctalia (default)";
            darkMode = true;
            schedulingMode = "off";
            manualSunrise = "06:30";
            manualSunset = "18:30";
            matugenSchemeType = "scheme-fruit-salad";
            generateTemplatesForPredefined = true;
          };
          templates = {
            gtk = true;
            qt = true;
            kcolorscheme = false;
            alacritty = false;
            kitty = false;
            ghostty = true;
            foot = false;
            wezterm = false;
            fuzzel = false;
            discord = false;
            discord_vesktop = false;
            discord_webcord = false;
            discord_armcord = false;
            discord_equibop = false;
            discord_lightcord = false;
            discord_dorion = false;
            pywalfox = false;
            vicinae = false;
            walker = false;
            code = false;
            enableUserTemplates = false;
          };
          nightLight = {
            enabled = false;
            forced = false;
            autoSchedule = true;
            nightTemp = "4000";
            dayTemp = "6500";
            manualSunrise = "06:30";
            manualSunset = "18:30";
          };
          hooks = {
            enabled = false;
            wallpaperChange = "";
            darkModeChange = "";
          };
          battery = {
            chargingMode = 0;
          };
        };
      };
    };

}
