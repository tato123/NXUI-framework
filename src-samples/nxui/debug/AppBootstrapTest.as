package nxui.debug 
{
	import flash.display.Sprite;
	import nxui.core.Nxui;
	import nxui.core.SceneBootstrapper;

	import nxui.debug.Scene01;
	import nxui.events.SceneEvent;
	import nxui.support.AwayStarlingEngine;
	
	
	/**
	 * 	
	 */
	[SWF(frameRate="30",backgroundColor="0x333333")]
	public class AppBootstrapTest extends Sprite
	{
		private var _engine:Nxui;
		
		
		public function AppBootstrapTest() 
		{
			_engine = new Nxui(this, AwayStarlingEngine);
			_engine.fullScreen = true;
			_engine.pushScene(Scene01);		
		}
		
	}

}

import nxui.debug.MyScene;

internal class DynamicLoader
{
	MyScene;
}
