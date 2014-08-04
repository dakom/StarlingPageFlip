package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(width="1024",height="768",frameRate="60", backgroundColor="#ffffff")]
	public class StarlingPageFlip extends Sprite
	{
		
		// Startup image for SD screens
		[Embed(source="../assets/compiletime/BG_SD.png")]
		private static var Background:Class;
		
		// Startup image for HD screens
		[Embed(source="../assets/compiletime/BG_HD.png")]
		private static var BackgroundHD:Class;
		
		[Embed(source="../assets/compiletime/FlashBG.jpg")]
		private static var FlashBackgroundClass:Class;
		
		private var viewPort:Rectangle;
		private var background:Bitmap;
		private var mStarling:Starling;
		
		private var originalFlashBackground:Bitmap = null;
		private var flashBackground:Bitmap = null;
		
		public function StarlingPageFlip()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Constants.isMobile = false;
			
			initStarling();
			
		}
		
		////////////////////////////////////////////////////////////
		/////////////	STARLING SETUP     /////////////////////////
		////////////////////////////////////////////////////////////
		
		public function initStarling() {
			viewPort = getStarlingViewport();
			
			getBackground();
			
			stage.addChild(background);
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true;
			
			mStarling = new Starling(StarlingPageFlipRoot, stage, viewPort);
			mStarling.stage.stageWidth = Constants.DESIGN_WIDTH;
			mStarling.stage.stageHeight = Constants.DESIGN_HEIGHT;
			mStarling.simulateMultitouch = false;
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onMainCreated);
			
			mStarling.start();
			
			trace("VIEWPORT:",viewPort, "SCALEFACTOR:",Starling.contentScaleFactor, "TEXTURESIZE", Constants.getTextureSize());
			
			/*
			Only if AIR....
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(true); });
			*/
			
		}
		
		private function onMainCreated(evt:starling.events.Event) {
			var bgTexture:Texture = Texture.fromBitmap(background, false, false, Starling.contentScaleFactor);
			
			
			bgTexture.root.onRestore = function():void {
				getBackground();
				bgTexture.root.uploadBitmapData(background.bitmapData);
				disposeBackgroundData();
				
			};
			
			
			(mStarling.root as StarlingPageFlipRoot).startApp(Image.fromBitmap(background, false, (Constants.getTextureSize() == Constants.TEXTURESIZE_SD) ? 1 : 2));
			stage.removeChild(background);
			disposeBackgroundData();
			
			stage.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(flash.events.Event.RESIZE, resizeStage);
			resizeStage();
		}
		
		
		private function getBackground() {
			disposeBackgroundData();
			if(Starling.current == null) {
				background = (stage.stageWidth <= Constants.DESIGN_WIDTH) ? new Background() : new BackgroundHD();
			} else {
				background = (Constants.getTextureSize() == Constants.TEXTURESIZE_SD) ? new Background() : new BackgroundHD();
			}
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
		}
		private function getStarlingViewport(stageWidth:uint = Constants.DESIGN_WIDTH, stageHeight:uint = Constants.DESIGN_HEIGHT):Rectangle {
			var tempViewPort:Rectangle;
			
			
			if(Constants.isMobile) {
				tempViewPort = RectangleUtil.fit(
					new Rectangle(0, 0, Constants.DESIGN_WIDTH, Constants.DESIGN_HEIGHT), 
					new Rectangle(0, 0,stage.fullScreenWidth, stage.fullScreenHeight), 
					ScaleMode.SHOW_ALL
				);
			} else {
				tempViewPort = RectangleUtil.fit(
					new Rectangle(0, 0, Constants.DESIGN_WIDTH, Constants.DESIGN_HEIGHT), 
					new Rectangle(0, 0,stage.stageWidth, stage.stageHeight), 
					ScaleMode.SHOW_ALL
				);
			}
			
			return(tempViewPort);
		}
		
		private function disposeBackgroundData() {
			if(background != null) {
				background.bitmapData.dispose();
				background = null;
			}
		}
		
		////////////////////////////////////////////////////////////
		/////////////	MAIN & STAGE EVENT LISTENERS     ///////////
		////////////////////////////////////////////////////////////
		
		
		
		
		private function onEnterFrame(evt:flash.events.Event) {
			
		}
		
		private function resizeStage(evt:flash.events.Event = null) {
			var spr:flash.display.Sprite;
			var bmd:BitmapData;
			var srcRect:Rectangle;
			
			viewPort = getStarlingViewport();
			
			
			mStarling.viewPort = viewPort;
			
			
			if(originalFlashBackground == null) {
				originalFlashBackground = new FlashBackgroundClass();
			}
			
			if(flashBackground != null) {
				stage.removeChild(flashBackground);
				flashBackground.bitmapData.dispose();
			}
			
			srcRect = new Rectangle(0,0,stage.stageWidth, stage.stageHeight);
			srcRect.x = (originalFlashBackground.width - srcRect.width)/2;
			srcRect.y = (originalFlashBackground.height - srcRect.height)/2;
			
			
			bmd = new BitmapData(stage.stageWidth, stage.stageHeight);
			bmd.copyPixels(originalFlashBackground.bitmapData, srcRect, new Point());
			bmd.fillRect(viewPort, 0);
			
			flashBackground = new Bitmap(bmd);
			
			stage.addChild(flashBackground);
			
		}
		
		
		
		
	}
}