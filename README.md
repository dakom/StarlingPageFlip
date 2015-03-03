StarlingPageFlip
================

**DEMO:**

Just open the html file in bin-release folder via your browser

Clicking/Touching on 20% of edge causes to flip, as does using navigation. Clicking in middle dispatches an event than can be used to do something with that page.

Note that it's using use-network=false and expects therefore to open locally via file://, not via server
Runtime images are in assets/runtime (not bin-release)

**FEATURES:**

Besides the basic flip capability, this dynamically adds internal shadows to sell the realism and plays nice with transparency (see rounded corners)

Also, the demo deals with scaling issues gracefully, though that's more of a general project issue than pageflip-specific.

**REQUIREMENTS TO COMPILE:**

1. Greensock (swc is here in lib folder)
2. Starling (version 1.6 included here)
3. Starling-Graphics extension (included here)

Also, make sure you include the "pageflip-source" folder into the build. It's separated out from src to allow different targets to build easily (web, mobile, desktop), even though only the web version is included on this repository.

**BUGS:**

1. Flipping toward end navigation is not smooth (compare to flipping toward start navigation)
2. Setting "SAFE_TOUCH" to false and playing around quickly can crash the app

**TO-DO - FEATURES (could _really_) use some help here!:**

1. Make flexible/bendy pages