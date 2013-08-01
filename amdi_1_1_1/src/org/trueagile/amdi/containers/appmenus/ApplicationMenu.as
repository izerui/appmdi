package org.trueagile.amdi.containers.appmenus
{
	import flash.events.Event;
	
	import org.trueagile.amdi.containers.MDIApplication;
	
	/**
	 * This interface is used for any Application Menu developed.
	 * @author mmarmol
	 * 
	 */
	public interface ApplicationMenu
	{
		function showMenu(event:Event):void;

        function hideMenu(event:Event=null):void;

        function set dataProvider(value:Object):void;

		function get dataProvider():Object

		function set mdiApplication(value:MDIApplication):void;

		function updateStyles():void;

	}
}