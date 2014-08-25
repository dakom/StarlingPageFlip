package book.pf
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Shape;
	import starling.display.starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.textures.GradientTexture;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;

	
	public class CachedImages extends starling.display.Sprite
	{
		
		public static const TABSIZE:Number = 10;
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		
		private var side:String;
		
		private static var totalCount:uint;
		private static var imgs:Array = null;
		private static var shadows:Array = null;
		
		private static var sHelperTouches:Vector.<Touch> = new <Touch>[];
		private var currentIndex:int;
		
		
		public function CachedImages(_side:String, _textures:Vector.<Texture>, _bmps)
		{
			var idx:uint;
			var img:Image;
			
			super();
			
			
			side = _side;
			
			if(imgs == null) {
				totalCount = _textures.length;
				imgs = new Array();
				shadows = new Array();
				
				for(idx = 0; idx < _textures.length; idx++) {
					imgs.push(new Image(_textures[idx]));
					shadows.push(makeShadow((idx%2 == 0) ? RIGHT : LEFT, _bmps[idx], idx));
				}
				
				
			}
			
			for(idx = 0; idx < imgs.length; idx++) {
				if(willShow(idx)) {
					img = imgs[idx];
					
					img.addEventListener(TouchEvent.TOUCH,onTouchHandler);
				}
			}
		}
		
	
		//Don't remember why the sizes works out like this... but it does :)
		private function makeShadow(shadowDirection:String, bmp:Bitmap, _idx:uint) {
			var shadowBMP:Bitmap;
			var bmpData:BitmapData;
			var img:Image;
			var mat:Matrix = new Matrix();
			var shadowSize:Number = TABSIZE*2;
			
			if(shadowDirection == RIGHT) {
				mat.translate(-(bmp.width - shadowSize*2), 0);
				
				bmp.filters = [new DropShadowFilter(0, 0, 0, 1,20,20, .5)];
				bmpData = new BitmapData(shadowSize*3, bmp.height, true, 0);
				bmpData.draw(bmp, mat, null, null, new Rectangle(0,0,shadowSize*3, bmpData.height));
				
			} else {
				mat.translate(shadowSize, 0);
				
				bmp.filters = [new DropShadowFilter(0, -180, 0, 1,20,20, .5)];
				bmpData = new BitmapData(shadowSize*3, bmp.height, true, 0);
				bmpData.draw(bmp, mat, null, null, new Rectangle(0,0,shadowSize*3, bmpData.height));
				
			}
			
			shadowBMP = new Bitmap(bmpData);
			img = Image.fromBitmap(shadowBMP);
			
			return(img);
		}
		
		
		
		private function onTouchHandler(evt:TouchEvent) {
			var touch:Touch;
			var idx:uint;
			var img:Image = evt.target as Image;
			
			sHelperTouches.length = 0;
			evt.getTouches(img, TouchPhase.BEGAN, sHelperTouches);
			for each(touch in sHelperTouches) {
				idx = imgs.indexOf(img);
				
				
				if(idx != currentIndex) {
					dispatchEventWith(Event.CHANGE, false, idx);
				}
			}
		}
		
		public function showImage(num:int) {
			var idx:int;
			var img:Image;
			var shadow:Image;
			var offset:int;
			
			removeChildren();
			
			currentIndex = num;
			
			
			//Don't remember why the shadow offsets work out like this... but it does :)
			
			if(num >= 0 && num < totalCount) {
				if(side == RIGHT) {
					for(idx = totalCount-1, offset = (idx-num); idx >= num; idx--, offset--) {
						if(willShow(idx)) {
							img = imgs[idx];
							
							if(idx == num) {
								
								img.x = 0;
								addChild(img);
							}
							
							shadow = shadows[idx];
							shadow.x = ((offset * TABSIZE) + img.width) - (TABSIZE*4);
							addChild(shadow);
							
						}
					}
					
				} else {
					for(idx = 0, offset = num; idx <= num; idx++, offset--) {
						if(willShow(idx)) {
							img = imgs[idx];
							if(idx == num) {
								
								img.x = 0;
								addChild(img);
							}
							
							shadow = shadows[idx];
							shadow.x = -((offset * TABSIZE) + (TABSIZE*2));
							addChild(shadow);
						}
					
					}
					
					
				}
			}
			
		}
		
		
		private function willShow(idx:int):Boolean {
			var ret:Boolean;
			
			if(((idx%2 == 0) && side == RIGHT) || ((idx%2 != 0) && side == LEFT)) {
				ret = true;
			} else {
				ret = false;
			}
			
			return(ret);
		}
		
	}
}