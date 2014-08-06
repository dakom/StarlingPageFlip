StarlingPageFlip
================

This is a fork of NeoGuo's pageflip, with a few new goals (work-in-progress).
The basic idea is to sacrifice some performance but gain new features

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
--* Ditch QuadBatch for cached pages
--* Use multiple QuadBatch's for soft pages
--* ShadowUtil operates on series of bitmaps instead of TextureAtlas
2. Pre-cache images (not necessarily better performance, depends on use case, but also necessary to allow for showing non-current images)
3. Keep old pages visible on stage- to for layering and seeing underneath, esp. useful with different shaped pages/covers
4. No reliance on classic flash shapes, rather use starling shapes (performance increase probably)

**TO-DO:**

1. Soft mode should pull from top or sides
2. Allow non-current pages to fan out, more 3d look (partially done since they are now in BG)
3. External shadows, more 3d look (could simply use Starling DropShadow filter?)
4. Make gotoPage fan through with animation
5. More fluidity for custom sizes
--* Internal Shadows should be created at runtime
6. Internal Shadows should mask by alpha channel of page

_Will update here as it's worked on_