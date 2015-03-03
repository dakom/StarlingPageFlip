package book.page
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Ease;
	import com.greensock.easing.ExpoIn;
	import com.greensock.easing.ExpoOut;
	import com.jewishinteractive.apps.booktest.appcommon.assets.AssetLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Page extends Sprite3D
	{
		public static const FRONT:String = 'front';
		public static const BACK:String = 'back';
		private var currentSide:String = FRONT;
		
		private var _pageIndex:uint;
		private var front:Image = null;
		private var back:Image = null;
		private var textures:Array = null;
		
		private var bmpFront:Bitmap;
		private var bmpBack:Bitmap;
		
		private static var sHelperPoint3D:Vector3D = new Vector3D();
		
		
		
		public function Page(_bmpFront:Bitmap, _bmpBack:Bitmap, __pageIndex:uint, totalPages:uint)
		{	
			super();
			
			bmpFront = _bmpFront;
			bmpBack = _bmpBack;
			_pageIndex = __pageIndex;
			
			if(_pageIndex > 0) {
				addShadowToBMP(bmpFront, FRONT, true);
			}
			if(_pageIndex < totalPages-1) {
				addShadowToBMP(bmpBack, BACK, true);
			}
			
			addEventListener(Event.ENTER_FRAME, updateVisibility);
			
		}
		
		override public function dispose():void {
			disposeImages();
			super.dispose();
		}
		
		public function disposeImages() {
			var texture:Texture;
			
			if(front != null) {
				front.dispose();
				removeChild(front);
				back.dispose();
				removeChild(back);
				front = null;
				back = null;
				
				for each(texture in textures) {
					texture.dispose();
				}
				textures = null;
				
				trace("CLEARED IMAGES!");
			}
		}
		
		public function createImages() {
			var texture:Texture;
			
			if(front == null) {
				textures = new Array();
				texture = Texture.fromBitmap(bmpFront);
				textures.push(texture);
				texture = Texture.fromBitmap(bmpBack);
				textures.push(texture);
				
				front = new Image(textures[0]);
				front.alignPivot();
				back = new Image(textures[1]);
				back.alignPivot();
				back.scaleX = -1;
				
				addChild(front);
				addChild(back);
				
				setPivot();
			}
		}
		
		private function setPivot() {
			this.alignPivot();
			this.pivotX = -getCurrentWidth()/2;
		}
		
		
		
		public function updateVisibility():void
		{
			
			if(front != null) {
				stage.getCameraPosition(this, sHelperPoint3D);
			
				front.visible = sHelperPoint3D.z <  0;
				back.visible  = sHelperPoint3D.z >= 0;
			
				if (scaleX * scaleY < 0) {
					front.visible = !front.visible;
					back.visible  = !back.visible;
				}
			}
		}
		
		public function flipPage(targetSide:String = null, _speed:Number = 1, _callbackWhenFinished:Function = null, ease:Function = null) {
			var targetRotation:Number;
			
			
			if(targetSide == null) {
				targetSide = (currentSide == FRONT) ? BACK : FRONT;
			}
			
			currentSide = targetSide;
			
			targetRotation = getTargetRotation();
			
			setPivot();
			
			TweenLite.to(this, _speed, {rotationY: targetRotation, onComplete: _callbackWhenFinished, ease: ease});
		}
		
		public function getTargetRotation():Number {
			return (currentSide == BACK) ? Math.PI : 0;
		}
		
		
		public function getCurrentWidth():Number {
			return((currentSide == FRONT) ? front.width : back.width);
		}
		
		private function addShadowToBMP(bmp:Bitmap, side:String, maskTransparency:Boolean = false) {
			var shadowWidth:Number = bmp.width/4;
			var shadowHeight:Number = bmp.height;
			var shape:Shape = new Shape();
			var shadowData:BitmapData;
			var rect:Rectangle;
			var point:Point;
			var mat:Matrix;
			
			
			mat = new Matrix();
			mat.createGradientBox(shadowWidth, shadowHeight);
			
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0,0,0,0], [.8,.6,.2,0], [0,2,130,255], mat);
			
			shape.graphics.drawRect(0,0,shadowWidth, shadowHeight);
			shape.graphics.endFill();
			
			shadowData = new BitmapData(shadowWidth, shadowHeight, true, 0);
			if(side == FRONT) {
				point = new Point();
				shadowData.draw(shape);
				bmp.bitmapData.copyPixels(shadowData, new Rectangle(0,0,shadowWidth,shadowHeight),point,maskTransparency ? bmp.bitmapData : null,null,true);
			} else {
				point = new Point(bmp.width-shadowWidth,0);
				shadowData.draw(shape, new Matrix( -1, 0, 0, 1, shadowWidth, 0));
				bmp.bitmapData.copyPixels(shadowData, new Rectangle(0,0,shadowWidth,shadowHeight),point,maskTransparency ? bmp.bitmapData : null, point, true);
			}
			
			
		}
	}
}