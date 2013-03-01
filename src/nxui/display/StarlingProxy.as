package nxui.display
{
	import flash.display.Stage;
	
	import away3d.core.managers.Stage3DProxy;
	
	import starling.core.Starling;


	public class StarlingProxy implements IEngineDisplayProxy
	{
		private var root:Class;
		private var antiAlias:int;

		
		public function StarlingProxy(root:Class, antiAlias:int=1)
		{
			this.root = root;
			this.antiAlias = antiAlias;
		}
		
		public function createInstance(stage:Stage, stage3DProxy:Stage3DProxy) : Object
		{			
			var starlingInstance:Starling =  new Starling(root, stage, stage3DProxy.viewPort,stage3DProxy.stage3D);
			starlingInstance.shareContext = true;
			starlingInstance.antiAliasing = antiAlias;
			return starlingInstance;
		}
		
		
		
			
		
	}
}