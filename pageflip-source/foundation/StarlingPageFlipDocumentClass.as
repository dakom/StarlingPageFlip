package foundation
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	
	public class StarlingPageFlipDocumentClass extends flash.display.Sprite
	{	
		
		// Startup image for SD screens
		[Embed(source="../../assets/compiletime/BG_SD.png")]
		private static var Background:Class;
		
		// Startup image for HD screens
		[Embed(source="../../assets/compiletime/BG_HD.png")]
		private static var BackgroundHD:Class;
		
		private var viewPort:Rectangle;
		private var background:Bitmap;
		private var mStarling:Starling;
		
		private var flashBGShape:Shape = null;
		private var flashBackground:Bitmap = null;
		
		public function StarlingPageFlipDocumentClass()
		{	
			super();
		
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		////////////////////////////////////////////////////////////
		/////////////	STARLING SETUP     /////////////////////////
		////////////////////////////////////////////////////////////
		
		public function initStarling(isMobile:Boolean) {
			Constants.isMobile = isMobile;
			
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
			
			mStarling.showStats = true;
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
			var mat:Matrix = new Matrix();
			var bmd:BitmapData;
			
			viewPort = getStarlingViewport();
			
			
			mStarling.viewPort = viewPort;
			
			
			if(flashBGShape == null) {
				flashBGShape = new Shape();
			} else {
				flashBGShape.graphics.clear();
			}
			
			if(flashBackground != null) {
				stage.removeChild(flashBackground);
				flashBackground.bitmapData.dispose();
			}
			
			
			
			
			mat.createGradientBox(stage.stageWidth, stage.stageHeight);
			flashBGShape.graphics.beginGradientFill(GradientType.RADIAL, [0x20241a, 0x0], [1,1],[0,255], mat);
			flashBGShape.graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
			flashBGShape.graphics.endFill();
			
			
			
			bmd = new BitmapData(stage.stageWidth, stage.stageHeight, true);
			bmd.perlinNoise(1000, 1000, 3, 50, true, true, 7, false);
			bmd.fillRect(viewPort, 0);
			
			flashBackground = new Bitmap(bmd);
			
			stage.addChild(flashBackground);
		}
	}
}