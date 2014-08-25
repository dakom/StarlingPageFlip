package book.pf
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.textures.Texture;

	public class DataConversion
	{
		public static function ClassicDisplayToBitmapData(disp:flash.display.DisplayObject):BitmapData {
			var bmpData:BitmapData;
			var bounds:Rectangle; 
			var mat:Matrix = new Matrix();
			var originalScaleX:Number = disp.scaleX;
			var originalScaleY:Number = disp.scaleY;
			
			disp.scaleX *= Starling.contentScaleFactor;
			disp.scaleY *= Starling.contentScaleFactor;
				
			bounds = disp.getBounds(disp.parent);
			
			mat.translate(-bounds.x, -bounds.y);
			mat.scale(Starling.contentScaleFactor, Starling.contentScaleFactor);
			
			bmpData = new BitmapData(disp.width, disp.height, true, 0); 
			bmpData.draw(disp, mat, null, null, null, true);
			
			
			disp.scaleX = originalScaleX;
			disp.scaleY = originalScaleY;
			return(bmpData);
		}
		
		public static function ClassicDisplayToTexture(disp:flash.display.DisplayObject, generateMipMaps:Boolean = false, optimizeForRenderToTexture:Boolean = false, format:String = "bgra"):Texture {
			var bmpData:BitmapData = ClassicDisplayToBitmapData(disp);
			var texture:Texture = Texture.fromBitmapData(bmpData,generateMipMaps, optimizeForRenderToTexture, Starling.contentScaleFactor, format); 
			
			texture.root.onRestore = function() {
				var newData:BitmapData = ClassicDisplayToBitmapData(disp);
				texture.root.uploadBitmapData(newData);
				newData.dispose();
			}
			bmpData.dispose();
			
			return(texture);
		}
		
		public static function ClassicDisplayToImage(disp:flash.display.DisplayObject, generateMipMaps:Boolean = false, optimizeForRenderToTexture:Boolean = false, format:String = "bgra"):Image {
			return(new Image(ClassicDisplayToTexture(disp, generateMipMaps, optimizeForRenderToTexture, format)));
		}
		
	}
}