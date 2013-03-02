package com.nxui.display
{
	import nxui.display.Scene;

	public class SceneProxy
	{
		private var activated:Date;
		private var _scene:Scene;
		private var _visible:Boolean = false;
		
		
		public function SceneProxy(scene:Scene)
		{
			activated = new Date();
			_scene = scene;
		}
		
		
		public function get visible() : Boolean
		{
			return _visible;
		}
		
		public function set visible(val:Boolean) : void
		{
			_visible = val;
		}
		
		
		public function get scene() : Scene
		{
			return _scene;
		}
	}
}