package foundation
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.Bitmap;
	
	import book.nav.NavigationContainer;
	import book.page.Page;
	import book.page.PageManager;
	import book.pf.PageFlipContainer;
	import book.pf.ShadowUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class StarlingPageFlipRoot extends Sprite
	{
		
		private static const bookWidth:Number = 800;
		private static const bookHeight:Number = 480;
		
		private var loaderMax:LoaderMax;
		
		
		private var pageManager:PageManager;
		private var navigationContainer:NavigationContainer;
		
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
				
				//navigationContainer.setCurrentIndex(8, false);
				//pageFlipContainer.gotoPage(9);
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
			
			
			pageManager = new PageManager(bmps);
			addChild(pageManager);
			pageManager.x = ((Constants.DESIGN_WIDTH - 400)/2) + 200;
			pageManager.y = 300;
			pageManager.addEventListener(Event.CHANGE, pageManagerChanged);
			pageManager.addEventListener(Event.OPEN, pageManagerSelected);
			
			navigationContainer = new NavigationContainer(bmps.length, Constants.DESIGN_WIDTH, Constants.DESIGN_HEIGHT);
			navigationContainer.addEventListener(Event.CHANGE, navigationChanged);
			navigationContainer.x = ((Constants.DESIGN_WIDTH - navigationContainer.width)/2);
			navigationContainer.y = 710;
			addChild(navigationContainer);
			
			
			navigationContainer.setCurrentIndex(0, false);
		}
		
		private function pageManagerChanged(evt:Event) {
			var newPageNum:int = (evt.data as int);
			
			navigationContainer.setCurrentIndex(newPageNum, false);
		}
		
		private function navigationChanged(evt:Event) {
			var newPageNum:int = (evt.data as int);
			pageManager.gotoPage(newPageNum);
			
		}
		
		private function pageManagerSelected(evt:Event) {
			var pageIndex:uint = evt.data.pageIndex;
			var side:String = evt.data.side;
			var finalDecision:uint = (side == Page.BACK) ? pageIndex+1 : pageIndex;
			
			
			trace("PAGE MANAGER:", pageIndex, "NAV:", navigationContainer.currentIndex, "SIDE:", side, "FINAL:", finalDecision);
		}
		
	}
}