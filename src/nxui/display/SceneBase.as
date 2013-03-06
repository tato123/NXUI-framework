package nxui.display
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import nxui.core.SceneBootstrapper;
	import nxui.core.SceneController;
	import flash.utils.*;
	import nxui.events.SceneEvent;
	import spark.components.Group;

	
	/**
	 * The SceneBase represents a logical grouping of all renderable
	 * items and controllers responsible for a level or view. 
	 * 
	 * 
	 */
	[Event(name = "initialize", type = "nxui.events.SceneEvent")]
	[Event(name = "onPause", type = "nxui.events.SceneEvent")]
	[Event(name = "onAppear", type = "nxui.events.SceneEvent")]
	[Event(name = "onDisappear", type = "nxui.events.SceneEvent")]
	public class SceneBase extends Group
	{
		/** Pause Game */
		private var _pause:Boolean;
		/** Scene Controller */
		private var _sceneController:SceneController;
		/** Scene Controller */
		private var _bootstrapper:SceneBootstrapper;

		/**
		 * Default Constructor
		 */
		public function SceneBase()
		{
			// Assign the controller
			//assignControllerFromMetadata();	
			
		}
		
		/**
		 * Call on scene descruction, if this object 
		 * is set to autodestruct then  NXUI will attempt to
		 * clean up this object through this method. 
		 * 
		 */
		public function dispose() : void
		{
			// TODO cleanup
		}
		
		
		//+----------------------------------------------------------------------------------------------
		// Abstract Methods
		//+----------------------------------------------------------------------------------------------		
		
		/**
		 * Handler for generating all the content
		 * @param	group
		 */
		public function generateRenderGroup(group:RenderGroup) : void
		{
			throw new Error("[Scene] Subclasses should override generateRenderGroup");
		}
		
		/**
		 * Will appear on the scene, pushing a scene does not 
		 * necessarily make it visible
		 */
		public function willAppear() : void			
		{
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_APPEAR));
		}		
		
		/**
		 * Runs the update pass for rendering
		 */
		public function update(delta:Number) : void
		{
			throw new Error("[Scene] Subclasses should override update");		
		}
		
		public function willDisappear() : void
		{
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_DISAPPEAR));
		}
		
		
		// +---------------------------------------------------------------------
		// Scene
		// +---------------------------------------------------------------------		
				
		public function set pause(val:Boolean) : void 
		{
			_pause = val;
			if ( _pause ) 
			{
				dispatchEvent(new SceneEvent(SceneEvent.PAUSE_SCENE));
			}
		}
		
		public function get pause() : Boolean
		{
			return _pause;
		}
		
		//+--------------------------------------------------------------------------
		// Getters / Setters
		//+--------------------------------------------------------------------------
		
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
			
			if ( child is RenderGroup) 
			{
				// Add the child
				super.addChild(child);
				// Generate it
				generateRenderGroup(RenderGroup(child));
			}
			else 
			{
				throw new Error("[NXUI-Scene] Must be of type RenderGroup");
			}
			
			return child;
		}
		
		/**
		 * Looks at the instance's metadata and if a controller is assigned then
		 * it uses that as the current scenecontroller
		 * 
		 * @return void
		 */
		private function assignControllerFromMetadata() : void
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
						sceneController = new ClassObject(this);
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

	}
}