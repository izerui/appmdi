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
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.controls.Menu;
	import mx.events.MenuEvent;
	
	/**
	 * This class represents the window menu button.
	 * @author mmarmol
	 * 
	 */
	public class MDIWindowMenuButton extends Button
	{
		private var _dataProvider:Object;
		public	var menu:Menu;
		public var window:MDIWindow;
		
		/**
		 * Basic constructor 
		 * @param dataProvider
		 * 
		 */
		public function MDIWindowMenuButton(dataProvider:Object)
		{
			this.dataProvider = dataProvider;
			enableShow();
		}
		
		/**
		 * Enable the button. 
		 * 
		 */
		public function enableShow():void{
			if (_dataProvider != null){
				this.addEventListener(MouseEvent.CLICK,showMenu);
				this.buttonMode=true;
			}
		}

		/**
		 * Disable the button. 
		 * 
		 */
		public function disableShow():void{
			this.removeEventListener(MouseEvent.CLICK,showMenu);
			this.buttonMode=false;
		}
			
		private function showMenu(event:MouseEvent):void {
			if (_dataProvider != null){
				var point:Point = this.localToGlobal(new Point(this.x,this.y));
				menu.show(point.x -3, point.y + this.height -2);
				menu.addEventListener(MenuEvent.MENU_SHOW,window.lisentMenuShow);
				menu.addEventListener(MenuEvent.ITEM_CLICK,window.lisentMenuItemClick);
			}
		}
		
		/**
		 * Force the menu to be hide. 
		 * 
		 */
		public function hideMenu():void{
			if (this.menu!=null){
				this.menu.hide();	
			}
		}
		
		/**
		 * Sets the menu with a xml. 
		 * @param value
		 * 
		 */
		public function set dataProvider(value:Object):void{
			this._dataProvider=value;
			this.menu = Menu.createMenu( null, _dataProvider, false );
			menu.labelField="label";
			menu.iconField="icon";
//			menu.variableRowHeight = true;
			menu.buttonMode=true;
			menu.validateNow();
			this.enableShow();
		}

		/**
		 * Returns the menu xml. 
		 * @return 
		 * 
		 */
		public function get dataProvider():Object{
			return this._dataProvider;
		}
			
	}
}