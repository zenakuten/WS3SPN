# WS3SPN
Wicked Sick 3SPN made to work with UTComp, originally based on [3SPNvSoL 3.18](https://github.com/zenakuten/3SPNvSoL) 

V19
- Fix crash from V18 (ty Calypto!)
- rewrite 3p view

V18
- Fix aiming in 3p view (adapted from superaerialview)
- Possible? fix for shock crash
- Limit the custom weapon color range to minimum rgb value
- Add server option to disable all view shake

V17
- fix channel leak when controllers join/leave

V16
- emote menu improvements
- fix floating/ghost players appearing in some ONS games

V15
- Fix bug with extra countdown in warmup in TAM / Freon 
- Add SRank/Elo scoreboard
- Add option to spawn at path nodes (this was hardcoded true)
- Add option to spawn at jump spots (this was hardcoded true)

V14
- More elo stats

V13
- Fix teams balance bug when new player joins after teams call

V12
- Add support for utcomp team radar on hud
- Add support for mutant style team radar on hud
- Add new awards: combo king, shock therapy, rockets go boom
- fix bug with crosshairs not working with widescreen fix

V11
- Fix more log spamming
- Fix can't fire weapons issue

V10
- Fix log spamming issue in freon
- Attempt fix for random weapon fire sounds in freon games
- Move server config to its own file

V9
- No changes.   Feature/bug changes in WSUTComp.

V8
- Code cleanup.  Feature/bug changes in WSUTComp.

V7
- Make stats work after warmup ends
- In F3 stats, fix duplicate listing when players change name colors mid-game
- Reverse FF changes
  * FriendlyFireScale affects damage to teammates only.
  * Enable RFF to use ReverseFFScale, ReverseFFScale affects damage to self. Default is 50% (0.5)

V6 
- Remove restriction on allowing mutators with 'UTComp' in the name like WeaponConfig
- Remove voice taunt ban feature, move similar to UTComp
- UI updates, darken menu was too transparent
- add Balls Deep message
- add possible fix for no weapon issue

V5
- Rename client config from `PlayerSettings3SPNCW.ini` to `WS3SPN.ini`
- clean up unused or duplicated code 

V4 
- Fix camp count after warmpup changes
- Fix self damage for spawn protected
- Use UTComp death messages and config


