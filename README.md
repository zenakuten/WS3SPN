# 3SPNvSoL
3SPN/TAM mutator customized for SoL, originally based on 3SPNv42102

v3.4
- remove random saveconfigs that broke bandwidthfix 

v3.3
- Add dodge fix from https://github.com/EliteTrials/ElitePatch 

v3.2
- Fix rubberbanding issue when there is high fps or high ping (thanks kokuei!)

v3.1
- Implement an optimal pickup spawn strategy. Pickup spawns are now govern by the `PickupMode` configuration option.
  - `Off (0)` - No pickups will spawn, same as setting `bRandomPickups` to `false`.
  - `Random (1)` - Original pickup spawn strategy, same as setting `bRandomPickups` to `true`.
  - `Optimal (2)` - New pickup spawn strategy.

v3.0
- fix necro message bug for TAM

v2.9
- server config to disable necro combo
- server config to disable necro 'Mate out RES' message

v2.8
- server config to allow 'boosted alt shield jump' (tich).  
- server config to allow pausing sounds

v2.7
- fix shock combo not working
- fix log spamming for lock rolloff

v2.6
- fix the rest of stats
- make fart sound for console commands client only

v2.5
- Restore DesiredNetUpdateRate player config option from 1.9, changes how often movement updates are sent to the server
- Add UseNetUpdateRate, MinNetUpdateRate, MaxNetUpdateRate to server config
- Add LockRolloff and RollOffMinValue to server config
- Make pawns always network relevant to help fix warp ins
- Add Fractional Rotation updates from 3SPHorst
- Stats fixes for LG, Shock, Link, Sniper, Assault, and Shield
- Fix bio secondary not using newnet

v2.4
- new player config option 'Play Own Landing Sound' under extras menu
- disable PauseSounds, UnPauseSounds, StopSounds commands

v2.3
- fix weird glitch on landing

v2.2
- new config option bKeepMomentumOnLanding, if true, no slowdown when landing from dodge or jump

v2.1
- server config to enable/disable weapon colors (default is enabled)
- add shield gun configs from 42109e 3spn
- specator hit sounds / indicators

v2.0
- stats update

v1.9
- disable landing sound if bPlayOwnFootsteps is false
- add server settings FootstepVolume and FootstepRadius for footstep sound
- remove unneccessary logging
- Add UTComp style movement updates
- Add ally/enemy logic for weapon colors, remove 'use brightskins' for weapon colors

v1.8
- increase config/webadmin setting for maxnetspeed.  It could be changed in the ini but using webadmin 
would force it to be within 9636-25000 range.  New range is 9636-100000

v1.7
- increase auto net speed max settings in gui
- add the rest of Fox WS Fix (thanks ds8k :) )
- add custom team colors for weapons
- add config option for abort necro sound

v1.6
- new config option "Auto Set Netspeed", set netspeed at match start
- new server options MinNetSpeed, MaxNetSpeed.  Admin can restrict netspeeds to a range.  
- new config option "Enable Widescreen Fix".  Add some widescreen fixes from Fox WS Fix.  Currently fixes crosshairs.  More to come.  (thanks ds8k!)
- new config options to enable team colors for rockets, bio, flak, and shock rifle.  

v1.5
- fix issue with booster sometimes not working
- new config option 'MinPlayersForStatsRecording', minimum players needed before recording stats, default is 2 (was hardcoded at 6)

V1.4
- fix 'teams' command

v1.3
- fix config option 'ReceiveAwards' not applying, was only doing 'player' awards previously
- change shield gun award to use haha sound

v1.2
- fix 1 kill combo whore bug (oops)
- change default receive award type to all

v1.1
- Add config option for SuddenDeathSound, SuddenDeath text, MatchPointSound, and MatchPoint text

[3SPNvSoL.Message_WinningRound]
SuddenDeathSound=Sound'SoL_Zoundz_1601.dod'
SuddenDeath=DO OR DIE!!!
;MatchPointSound=...
;MatchPoint=This is MATCH POINT!!!

- Add Map prefix to fix issue with MapList.  Freon maps must start with 'FR-'
- Update help text for play own footsteps checkbox "(weapon bob must be OFF!!!)"
- rename 'Damage' submenu to 'extra'
- Add 'ReceiveAward' configuration to 'extra' sub menu.  Default is 'Player'
- Add 'Use classic 3SPN death messages' to colored names sub menu. Default is false.


v1.0 initial release, based off 3SPNv42102

new in vSoL
- Add options for FastWeaponSwitch, boost dodge
- Add Eye height fix
- remove sniper type stuff
