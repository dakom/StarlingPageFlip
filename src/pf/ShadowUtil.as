package pf
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ShadowUtil
	{
		
		public static function addShadowsToBMPs(inputBitmaps:Array, pageWidth:Number, pageHeight:Number, maskTransparency:Boolean = false) {
			var shadowWidth:Number = pageWidth/4;
			var shadowHeight:Number = pageHeight;
			var bmp:Bitmap;
			var count:int = 0;
			var shape:Shape = new Shape();
			var leftShadowData:BitmapData;
			var rightShadowData:BitmapData;
			var rect:Rectangle;
			var point:Point;
			var targetShadowData:BitmapData;
			var mat:Matrix;
			
			mat = new Matrix();
			mat.createGradientBox(shadowWidth, shadowHeight);
			
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0,0,0,0], [.8,.6,.2,0], [0,2,130,255], mat);
			shape.graphics.drawRect(0,0,shadowWidth, shadowHeight);
			shape.graphics.endFill();
			
			rightShadowData = new BitmapData(shadowWidth, shadowHeight, true, 0);
			rightShadowData.draw(shape);
			
			leftShadowData = new BitmapData(shadowWidth, shadowHeight, true, 0);
			leftShadowData.draw(shape, new Matrix( -1, 0, 0, 1, shadowWidth, 0));
			
			
			
			
			for(count = 1; count < inputBitmaps.length-1; count++) {
				bmp = inputBitmaps[count];
				
				if(count%2==0) {
					point = new Point();
					targetShadowData = rightShadowData;
				} else {
					point = new Point(bmp.width-shadowWidth,0);
					targetShadowData = leftShadowData;
				}
				
				bmp.bitmapData.copyPixels(targetShadowData, new Rectangle(0,0,shadowWidth,shadowHeight),point,maskTransparency ? bmp.bitmapData : null,null,true);
			}
		}
	}
}