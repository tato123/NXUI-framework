package nxui.events
{
	import flash.events.Event;
	
	public class NxuiEvent extends flash.events.Event
	{
		public function NxuiEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		// Define static constant.
		public static const CONTEXT_CREATED:String = "created";
		public static const FRAMEWORK_INITIALIZED:String = "frameworkInitialized";
		
		// Define a public variable to hold the state of the enable property.
		public var isEnabled:Boolean;
		
		// Override the inherited clone() method.
		override public function clone():flash.events.Event {
			return new nxui.events.NxuiEvent(type, isEnabled);
		}
	}
}