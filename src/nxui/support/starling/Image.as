package nxui.support.starling
{
	import nxui.core.Nxui;
	import nxui.display.Stage3DRenderObject;
	
	import starling.display.Image;
	import starling.textures.Texture;


	public class Image extends Stage3DRenderObject
	{
		private var rawInstance:Object;
		public var antiAlias:int;
		[Bindable]
		public var _source:Class;
		
		public function set source(val:Class) : void 
		{
			if ( val != null ) 
			{
				_source = val;
				Nxui.current.enqueue(_source);
			}
						
		}
		
		public function get source() : Class 
		{
			return _source;
		}
		
		override public function createInstance() : Object
		{
			
			
			var texture:Texture = Nxui.current.assetManager.getTexture("_source");
			var img:starling.display.Image = new starling.display.Image(texture);
			rawInstance = img;
			
			return null;	
		}
		
			
		
	}
}