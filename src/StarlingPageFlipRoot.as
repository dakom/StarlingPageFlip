package
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	
	import pf.PageFlipContainer;
	import pf.ShadowUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class StarlingPageFlipRoot extends Sprite
	{
		
		
		
		private var loaderMax:LoaderMax;
		
		private var pageFlipContainer:PageFlipContainer;
		
		private var images:Array = [	'StartCover_Front',
										'StartCover_Back',
										'OldPage001',
										'OldPage002',
										'OldPage003',
										'OldPage004',
										'OldPage005',
										'OldPage006',
										'OldPage007',
										'OldPage008',
										'EndCover_Front',
										'EndCover_Back'
		];
		private var imgName:String;
		
		public function StarlingPageFlipRoot()
		{
			super();
				
		}
		
		public function startApp(bgImage:Image):void
		{
			
				
			addChild(bgImage);
			
			loaderMax = new LoaderMax();
			loaderMax.addEventListener(LoaderEvent.COMPLETE, assetsLoaded);
		
			
			for each(imgName in images) {
				loaderMax.append(new ImageLoader(getRuntimePath(imgName + ".png"), {name: imgName}));
			}
			
			
			loaderMax.load();
		}
		
		
		private function getRuntimePath(path:String):String {
			return("../assets/runtime/" + path);
		}
		private function assetsLoaded(evt:LoaderEvent) {
			if(loaderMax.getChildren(true).length != loaderMax.getChildrenByStatus(LoaderStatus.COMPLETED, true).length) {
				throw new Error("Error loading runtime assets!");
			} else {
				showPageFlip();	
			}
		}
		
		private function showPageFlip() {
			var textures:Vector.<Texture> = new Vector.<Texture>();
			var texture:Texture;
			var bmp:Bitmap;
			var bmps:Array = new Array();
			
			for each(imgName in images) {
				bmps.push((loaderMax.getLoader(imgName) as ImageLoader).rawContent);
			}
			
			ShadowUtil.addShadowsToBMPs(bmps);
			
			for each(bmp in bmps) {
				texture = Texture.fromBitmap(bmp);	
				textures.push(texture);
			}
			
			pageFlipContainer = new PageFlipContainer(textures,800,480,8);
			pageFlipContainer.x = 100;
			pageFlipContainer.y = 100;
			addChild(pageFlipContainer);
		}
	}
}