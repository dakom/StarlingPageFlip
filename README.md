StarlingPageFlip
================

**DEMO:**

Just open the html file in bin-release folder via your browser

Note that it's using use-network=false and expects therefore to open locally via file://, not via server
Runtime images are in assets/runtime (not bin-release)

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