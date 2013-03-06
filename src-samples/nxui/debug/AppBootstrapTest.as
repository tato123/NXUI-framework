package nxui.debug 
{
	import flash.display.Sprite;
	import nxui.core.SceneBootstrapper;

	import nxui.debug.Scene01;
	import nxui.events.SceneEvent;
	
	
	
	/**
	 * 	
	 */
	[SWF(frameRate="30",backgroundColor="0x333333")]
	public class AppBootstrapTest extends Sprite
	{
		private var _bootstrapper:SceneBootstrapper;
		
		
		public function AppBootstrapTest() 
		{
			_bootstrapper = new SceneBootstrapper();
			_bootstrapper.addEventListener(SceneEvent.LOAD_COMPLETE, onLoadComplete);
			_bootstrapper.addEventListener(SceneEvent.LOAD_ERROR, onLoadError);
			_bootstrapper.loadScene(nxui.debug.Scene01);			
		}
		
		/**
		 * Do something here
		 * @param	evt
		 */
		public function onLoadComplete(evt:SceneEvent) : void
		{
			trace("Loading Complete");
		}
		
		/**
		 * Do something here
		 * @param	evt
		 */
		public function onLoadError(evt:SceneEvent) : void
		{
			trace("Load Error");
		}
		
	}

}

import nxui.debug.MyScene;

internal class DynamicLoader
{
	MyScene;
}
