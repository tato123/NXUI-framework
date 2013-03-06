package nxui.display
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	
	import away3d.core.managers.Stage3DProxy;

	public interface IEngineDisplayProxy
	{
		function createInstance(stage:Stage, viewPort:Rectangle, stage3D:Stage3D) : Object;
	}
	
}