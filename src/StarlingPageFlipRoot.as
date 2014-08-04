package
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import pf.PageFlipContainer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class StarlingPageFlipRoot extends Sprite
	{
		
		
		private var loaderMax:LoaderMax;
		
		private var pageFlipContainer:PageFlipContainer;
		
		
		public function StarlingPageFlipRoot()
		{
			super();
				
		}
		
		public function startApp(bgImage:Image):void
		{
			addChild(bgImage);
			
			loaderMax = new LoaderMax();
			loaderMax.addEventListener(LoaderEvent.COMPLETE, assetsLoaded);
		
			
			loaderMax.append(new ImageLoader(getRuntimePath("flash-pf.png"), {name: 'atlas-img'}));
			loaderMax.append(new XMLLoader(getRuntimePath("flash-pf.xml"), {name: 'atlas-xml'}));
			
			loaderMax.load();
		}
		
		
		private function getRuntimePath(path:String):String {
			return("runtime/" + path);
		}
		private function assetsLoaded(evt:LoaderEvent) {
			if(loaderMax.getChildren(true).length != loaderMax.getChildrenByStatus(LoaderStatus.COMPLETED, true).length) {
				throw new Error("Error loading runtime assets!");
			} else {
				showPageFlip();	
			}
		}
		
		private function showPageFlip() {
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap((loaderMax.getLoader('atlas-img') as ImageLoader).rawContent), (loaderMax.getLoader('atlas-xml') as XMLLoader).content);
			
			pageFlipContainer = new PageFlipContainer(atlas.getTextures(),800,480,8);
			pageFlipContainer.x = 100;
			pageFlipContainer.y = 100;
			addChild(pageFlipContainer);
			
		}
	}
}