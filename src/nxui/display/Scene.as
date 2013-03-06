package nxui.display
{
	
	
	[Event(name = "initialize", type = "nxui.events.SceneEvent")]
	[Event(name = "addedToStage", type = "nxui.events.SceneEvent")]	
	[Event(name = "removedFromStage", type = "nxui.events.SceneEvent")]	
	[Event(name = "onPause", type = "nxui.events.SceneEvent")]
	[Event(name = "onAppear", type = "nxui.events.SceneEvent")]
	public class Scene
	{

		private var _pause:Boolean;
		private var _sceneController:SceneController;
		private var _contentType:String;
		private var _bootstrapper:SceneBootstrapper;

		
		/**
		 * Default Constructor
		 */
		public function Scene()
		{
			// If this scene was created from an xml introspect to
			// see if scene controller metadata was defined 
			var metadata:XMLList = describeType(this).metadata.(@name == "SceneController");
			if ( metadata ) 
			{				
				try 
				{
					// Default key
					var value:String = metadata.arg.(@key == "").@value;	
					var ClassObject:Class = getDefinitionByName(value) as Class;
					if ( ClassObject ) 
					{
						_sceneController = new ClassObject(this);
					}
				}
				catch ( error:Error ) 
				{
					trace( "[NXUI-Scene] Cannot dynamically generate type, verify that it has been defined.");
				}
			}
			
			// Trace the available metadata
			trace(metadata);			
		}
		
		public function willAppear() : void			
		{
			// Do something here if we want to 
		}
		
		
		public function update(delta:Number) : void
		{
			// This method should be overriden in subclasses
		}
		
		public function willDisappear() : void
		{
			
		}
		
		
		// +---------------------------------------------------------------------
		// Scene
		// +---------------------------------------------------------------------		
				
		public function set pause(val:Boolean) : void 
		{
			_pause = val;
		}
		
		public function get pause() : Boolean
		{
			return _pause;
		}
		
		//+--------------------------------------------------------------------------
		// Getters / Setters
		//+--------------------------------------------------------------------------
		
		[Inspectable(enumeration="mixed,2d,3d", defaultValue="mixed")] 
		public function set contentType(val:String) : void
		{
			_contentType = val;
		}
		
		public function get contentType() : String
		{
			return _contentType;		
		}
		
		public function set sceneController(val:SceneController) : void
		{
			_sceneController = val;
		}
		
		public function get sceneController() : SceneController
		{
			return _sceneController;		
		}
		
		public function get bootstrapper() :SceneBootstrapper
		{
			return _bootstrapper;
		}
		
		public function set bootstrapper(val:SceneBootstrapper) : void
		{
			_bootstrapper = val;
		}
		
		//+--------------------------------------------------------------------------
		// Overrides to handle what is allowed
		//+--------------------------------------------------------------------------
			
		override public function addChild(child:DisplayObject) : DisplayObject
		{
			
			throw new Error("Not Supported");			
		}
		
		override public function addElement(element:IVisualElement) : IVisualElement
		{
			if ( element is RenderGroup) 
			{
				return super.addElement(element);
			}
			else 
			{
				throw new Error("[NXUI-Scene] Must be of type RenderGroup");
			}
			
			return null;
		}
		
		//+--------------------------------------------------------------------------
		// Convenience 
		//+--------------------------------------------------------------------------
		
		/**
		 * Scene is activated, this is essentially 
		 * 
		 * 
		 * 
		 */
		public function pause() : void
		{
			dispatchEvent(new SceneEvent(SceneEvent.PAUSE_SCENE));
		}
		
		public function deactiviate() : void
		{
			
		}
	}
}