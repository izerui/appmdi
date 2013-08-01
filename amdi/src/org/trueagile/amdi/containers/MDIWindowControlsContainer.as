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
	import flash.display.DisplayObject;
	
	import mx.controls.Button;
	import mx.core.ContainerLayout;
	import mx.core.LayoutContainer;
	import mx.core.UITextField;
	
	/**
	 * Class that holds window control buttons and handles general titleBar layout.
	 * Provides minimize, maximize/restore and close buttons by default.
	 * Subclass this class to create custom layouts that rearrange, add to, or reduce
	 * the default controls. Set layout property to switch between horizontal, vertical 
	 * and absolute layouts.
	 */
	public class MDIWindowControlsContainer extends LayoutContainer
	{
		public var window:MDIWindow;
		public var minimizeBtn:Button;
		public var maximizeRestoreBtn:Button;
		public var closeBtn:Button;
		
		/**
		 * Base class to hold window controls. Since it inherits from LayoutContainer, literally any layout
		 * can be accomplished by manipulating or subclassing this class.
		 */
		public function MDIWindowControlsContainer()
		{
			layout = ContainerLayout.HORIZONTAL;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!minimizeBtn)
			{
				minimizeBtn = new Button();
				minimizeBtn.buttonMode = true;
				addChild(minimizeBtn);
			}
			
			if(!maximizeRestoreBtn)
			{
				maximizeRestoreBtn = new Button();
				maximizeRestoreBtn.buttonMode = true;
				addChild(maximizeRestoreBtn);
			}
			
			if(!closeBtn)
			{
				closeBtn = new Button();
				closeBtn.buttonMode = true;
				addChild(closeBtn);
			}
		}
		
		/**
		 * Traditional override of built-in lifecycle function used to control visual 
		 * layout of the class. Minor difference is that size is set here as well because
		 * automatic measurement and sizing is not handled by framework since we go into 
		 * rawChildren (of MDIWindow).
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			// since we're in rawChildren we don't get measured and laid out by our parent
			// this routine finds the bounds of our children and sets our size accordingly
			var minX:Number = 9999;
			var minY:Number = 9999;
			var maxX:Number = -9999;
			var maxY:Number = -9999;
			for each(var child:DisplayObject in this.getChildren())
			{
				minX = Math.min(minX, child.x);
				minY = Math.min(minY, child.y);
				maxX = Math.max(maxX, child.x + child.width);
				maxY = Math.max(maxY, child.y + child.height);
			}
			this.setActualSize(maxX - minX, maxY - minY);
			
			// now that we're sized we set our position
			// right aligned, respecting border width
			this.x = window.width - this.width - Number(window.getStyle("borderThicknessRight"));
			// vertically centered
			this.y = (window.titleBarOverlay.height - this.height) / 2;
			
			// lay out the title field and icon (if present)
			var tf:UITextField = window.getTitleTextField();
			var icon:DisplayObject = window.getTitleIconObject();
			if (window.menuBtn){
				tf.x = window.menuBtn.x + window.menuBtn.width + Number(window.getStyle("borderThicknessLeft")) ;	
			}
			else{
				tf.x =  Number(window.getStyle("borderThicknessLeft")) ;
			}
			
			
			if(icon)
			{
				icon.x = tf.x;
				tf.x = icon.x + icon.width + 4;
			}
			
			// ghetto truncation
			if(!window.minimized)
			{
				tf.width = this.x - tf.x;
			}
			else
			{
				tf.width = window.width - tf.x - 4;
			}
		}
	}
}