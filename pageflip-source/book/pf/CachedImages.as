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
		
		public static const TABSIZE:Number = 20;
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public var currentIndex:int;
		
		private static const shadowSize:Number = (TABSIZE*2);
		private static var totalCount:uint;
		private static var imgs:Array = null;
		private static var shadows:Array = null;
		
		
		private var side:String;
		
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
					img = new Image(_textures[idx]);
					imgs.push(img);
					
					img = makeShadow((idx%2 == 0) ? RIGHT : LEFT, _bmps[idx], idx);
					shadows.push(img);
				}
			}
			
			//this.touchable = false;
		}
		
	
		//Don't remember why the sizes works out like this... but it does :)
		private function makeShadow(shadowDirection:String, bmp:Bitmap, _idx:uint):Image {
			var shadowBMP:Bitmap;
			var bmpData:BitmapData;
			var img:Image;
			var mat:Matrix = new Matrix();
			
			if(shadowDirection == RIGHT) {
				mat.translate(-(bmp.width - shadowSize), 0);
				
				bmp.filters = [new DropShadowFilter(0, 0, 0, 1,20,20, .5)];
				bmpData = new BitmapData(shadowSize*2, bmp.height, true, 0);
				bmpData.draw(bmp, mat, null, null, new Rectangle(0,0,shadowSize*2, bmpData.height));
				
			} else {
				mat.translate(shadowSize, 0);
				
				bmp.filters = [new DropShadowFilter(0, -180, 0, 1,20,20, .5)];
				bmpData = new BitmapData(shadowSize*2, bmp.height, true, 0);
				bmpData.draw(bmp, mat, null, null, new Rectangle(0,0,shadowSize*2, bmpData.height));
				
			}
			
			shadowBMP = new Bitmap(bmpData);
			img = Image.fromBitmap(shadowBMP);
			
			return(img);
		}
		
		public function showImage(num:int) {
			var idx:int;
			var shadow:Image;
			var offset:int;
			var fullImage:Image;
			
			if((currentIndex == num && this.numChildren) || (num < 0 || num >= totalCount)) {
				if(currentIndex != num) {
					removeChildren();
				}
				return;
			}
			
			removeChildren();
			currentIndex = num;
			
			fullImage = imgs[currentIndex];
			
			
			if(side == RIGHT) {
				for(idx = totalCount-1; idx >= num; idx--) {
					if((idx%2 == 0) && idx != (totalCount-1)) {
						shadow = shadows[idx];
						
						offset = idx - num;
						
						shadow.x = (fullImage.width - shadowSize) + ((offset) * (TABSIZE/2));
						addChild(shadow);
					}
				}
				
			} else {
				for(idx = 0; idx <= num; idx++) {
					if((idx%2 != 0) && idx) {
						shadow = shadows[idx];
						
						offset = num-idx;
						
						shadow.x = -(shadowSize + ((offset) * (TABSIZE/2)));
						addChild(shadow);
					}
					
				}
				
				
			}
			
			addChild(fullImage);
			
		}
	}
}