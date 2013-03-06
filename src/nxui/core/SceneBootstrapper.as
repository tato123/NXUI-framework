package nxui.core 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.containers.Canvas;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	import mx.managers.PopUpManager;
	import nxui.display.SceneBase;
	import nxui.events.SceneEvent;
	
	
	/**
	 * Bootstrapper is responsible for reading a collection of 
	 * view classes and creating dynamic scenes
	 */
	[Event(name = "onLoadError", type = "nxui.core.events.SceneEvent")]
	[Event(name = "onLoadSuccess", type = "nxui.core.events.SceneEvent")]	
	public class SceneBootstrapper extends EventDispatcher
	{
		// Loader
		private var loader:SceneLoader;

		
		/**
		 * Default Constructor
		 */
		public function SceneBootstrapper()
		{
			loader = new SceneLoader();
			addEventListener(AsyncBootstrapEvents.BUILD_SCENE, sceneBuilder);
		}
		
		//----------------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------------
		
		/**
		 * Build a scene
		 * @param	evt
		 */
		private function sceneBuilder(evt:AsyncBootstrapEvents) : void
		{
			buildScenes(evt.scenes);				
		}
		
		//----------------------------------------------------------------------------
		// Event handlers
		//----------------------------------------------------------------------------
		
		
		/**
		 * Load a new scene 
		 * @param	sceneFile
		 */
		public function loadScene(...scenes) : void
		{
			var bootstrapEvent:AsyncBootstrapEvents = new AsyncBootstrapEvents(AsyncBootstrapEvents.BUILD_SCENE);
			bootstrapEvent.scenes = scenes;
			dispatchEvent(bootstrapEvent);
		}
		
		/**
		 * Validation phase of scene objects
		 * to make sure each is of the right type
		 * and well defined
		 */
		private function validateScene(instance:Object) : Boolean
		{
			if ( instance is SceneBase)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Build our scenes
		 * @param	...scenes
		 */
		private function buildScenes(...scenes) : void
		{
			// All the new scene references that were created
			var sceneref:Array = [];
			// 
			for each ( var SceneClassArray:Array in scenes ) 
			{
				for each ( var SceneClass:Class in SceneClassArray)
				{			
					var instance:SceneBase = new SceneClass() as SceneBase;		
					instance.bootstrapper = this;
					if (validateScene(instance))
					{
						sceneref.push(instance);
						loader.pushType(instance);
					}
				}				
			}
			
			// Done Dispatch event
			var sceneEvent:SceneEvent = new SceneEvent(SceneEvent.LOAD_COMPLETE);
			sceneEvent.scenes = sceneref;
			dispatchEvent(sceneEvent);		
		}
		
	}
}
import flash.events.Event;

class AsyncBootstrapEvents extends Event
{
	 // Public constructor.
        public function AsyncBootstrapEvents(type:String, 
            isEnabled:Boolean=false) {
                // Call the constructor of the superclass.
                super(type);
    
                // Set the new property.
                this.isEnabled = isEnabled;
        }

        // Define static constant.
        public static const BUILD_SCENE:String = "buildscene";

        // Define a public variable to hold the state of the enable property.
        public var isEnabled:Boolean;
		
		public var scenes:Array;

        // Override the inherited clone() method.
        override public function clone():Event {
            return new AsyncBootstrapEvents(type, isEnabled);
        }
}