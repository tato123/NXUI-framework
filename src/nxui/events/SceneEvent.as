package nxui.events 
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 */
	public class SceneEvent extends Event
	{
		
		// Public constructor.
        public function SceneEvent(type:String, 
            isEnabled:Boolean=false) {
                // Call the constructor of the superclass.
                super(type);
    
                // Set the new property.
                this.isEnabled = isEnabled;
        }

        // Define static constant.
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
        public static const BUILD_SCENE:String = "buildscene";
		public static const PAUSE_SCENE:String = "pausescene";
		
		
        // Define a public variable to hold the state of the enable property.
        public var isEnabled:Boolean;
		
		public var scenes:Array;

        // Override the inherited clone() method.
        override public function clone():Event {
            return new SceneEvent(type, isEnabled);
        }
		
	}

}