package nxui.display
{
	import flash.display.Stage;
	
	import away3d.core.managers.Stage3DProxy;

	public interface IEngineDisplayProxy
	{
		function createInstance(stage:Stage, stage3DProxy:Stage3DProxy) : Object;
	}
}