package nxui.support.starling
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import starling.textures.Texture;
	
	import flash.geom.Rectangle;
	import nxui.display.Stage3DRenderObject;	
	import away3d.core.managers.Stage3DProxy;	
	import starling.display.Image;


	public class Image extends Stage3DRenderObject
	{
		
		public var antiAlias:int;
		[Bindable]
		public var source:Class;
		
		
		
				
		override public function createInstance(stage:Stage, viewPort:Rectangle, stage3D:Stage3D) : Object
		{			
			var texture:Texture = Texture.fromBitmap(new source());
			var img:starling.display.Image = new starling.display.Image(texture);
			return img;
		}
		
		
		
			
		
	}
}