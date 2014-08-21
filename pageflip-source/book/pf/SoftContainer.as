package book.pf
{
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	
	public class SoftContainer extends Sprite
	{
		private var quads:Dictionary;
		
		public function SoftContainer()
		{
			super();
			
			quads = new Dictionary();
		}
		
		override public function dispose():void {
			quads = null;
			super.dispose();
		}
		
		public function resetQuads() {
			var qb:QuadBatch;
			
			for each(qb in quads) {
				qb.reset();
			}
		}
		public function addImage(img:Image) {
			var qb:QuadBatch;
			
			if(!quads[img.texture]) {
				quads[img.texture] = new QuadBatch();
				addChild(quads[img.texture]);
			}
			
			qb = quads[img.texture];
			
			qb.addImage(img);
			
			
		}
	}
}