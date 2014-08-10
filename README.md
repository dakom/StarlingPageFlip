StarlingPageFlip
================

This is a fork of NeoGuo's Starling-powered pageflipper, with a few new features and goals (work-in-progress).

The basic idea is to sacrifice some significant performance but gain some significant new features :)

If all you need is to pop in a texture atlas and flip through the book at a predefined size and not see hidden pages till uncovered- use NeoGuo's version, it is faster for that

If, on the other hand, you need the "New Features" here (see below), this is a great starting point imho.

**DEMO:**

Just open the html file in bin-release folder via your browser

Note that it's using use-network=false and expects therefore to open locally via file://, not via server
Runtime images are in assets/runtime (not bin-release)

**REQUIREMENTS:**

1. Greensock (swc is here in lib folder)
2. Starling (swc is here in lib folder)
3. Starling-Graphics extension (source in src folder)

**NEW FEATURES:**

1. Dynamic Images (Remove need for TextureAtlas)
  * Ditch QuadBatch for cached pages
  * Use multiple QuadBatch's for soft pages
  * ShadowUtil operates on series of bitmaps instead of TextureAtlas
2. Pre-cache images (not necessarily better performance, depends on use case, but also necessary to allow for showing non-current images)
3. Keep old pages visible on stage- for layering and seeing underneath, esp. useful with different shaped pages/covers
4. No reliance on classic flash shapes (other than inner page shadow), rather use starling shapes wherever shapes are needed
5. Internal shadows are created at runtime (check out ShadowUtil- can adjust parameters there for different look)
6. Internal shadows can mask by alpha channel of page (default is off, since it bleeds a bit)
7. Navigation
  * Events dispatched when book changed (exact page that was used to cause the change)
  * External ability to set book for change
  * Proof-of-concept visuals for demo (note event suppression for navigation setting)
8. Nothing to do with pageflipping itself, but still- when screen size changes, classic flash handles underlying BG while starling scales to fit proportionally
  * Using Perlin Noise with constants to demonstrate how that can be used to maintain resolution
  * In a real project, starling BG should blend seamlessly into Flash BG
  * Easy way to simulate a pseudo-liquid layout, or at least something a little better than black bars, without dealing in Starling
  
**TO-DO:**

**Could _really_ use some help on these essential but difficult items:**
1. Soft mode should allow pulling from top or sides, not just bottom corner (this might not be so hard if you're familiar with gpu stuff)
2. Make gotoPage fan through with animation

**Easier to-do items that are still essential:**
3. More fluidity for custom sizes
 
**These are not as essential, more just icing on the cake**
4. Allow non-current pages to fan out, more 3d look (partially done since they are now in BG)
5. External shadows, more 3d look (could simply use Starling DropShadow filter?)
