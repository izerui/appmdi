/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.containers
{	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import org.trueagile.amdi.containers.appmenus.ApplicationMenu;
	
	/**
	 * This class represents the button for the main application. 
	 * @author chelo
	 * 
	 */
	public class MDIApplicationMenuButton extends Button
	{
		private var _menuXML:XML;
		private var _menu:ApplicationMenu;
		public var mdiApplication:MDIApplication;
		public var isShowing:Boolean=false;
		public var appBar:MDIApplicationBar;
				
		/**
		 *Basic constructor 
		 * 
		 */
		public function MDIApplicationMenuButton(mdiApplication:MDIApplication) 
		{
			this.mdiApplication=mdiApplication;
			enableShow();
		}

		/**
		 *Enable the button to be show. 
		 * 
		 */
		public function enableShow():void{
			if (_menuXML != null){
				this.addEventListener(MouseEvent.CLICK,showMenu);
				this.buttonMode=true;
			}
		}

		/**
		 * Disable the button to be show. 
		 * 
		 */
		public function disableShow():void{
			this.removeEventListener(MouseEvent.CLICK,showMenu);
			this.buttonMode=false;
		}
			
		private function showMenu(event:MouseEvent):void {
			_menu.showMenu(event);
			isShowing=true;
		}

		/**
		 * Hide the menu button. 
		 * @param event
		 * 
		 */
		public function hideMenu(event:FlexEvent=null):void{
			_menu.hideMenu(event);
			isShowing=false;
			this.appBar.handleZoom();
		}
		
		/**
		 * Sets the menu based in a xml for the button. 
		 * @param value
		 * 
		 */
		public function set menuXML(value:XML):void{
			this._menuXML=value;
			_menu.menuXML=value;
			this.enableShow();
		}

		/**
		 * Returns the menu based in a xml for the button. 
		 * @return
		 * 
		 */		
		public function get menuXML():XML{
			return this._menuXML;
		}

		/**
		 * Sets the Application Menu for the button. 
		 * @return
		 * 
		 */		
		public function set menu(value:ApplicationMenu):void{
			if (this._menu){
				this._menu.hideMenu();
			}
			this._menu=value;
			this._menu.updateStyles();
		}

		/**
		 * Gets the Application Menu for the button. 
		 * @return
		 * 
		 */		
		public function get menu():ApplicationMenu{
			return _menu;
		}

	}
}