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
	import org.trueagile.amdi.managers.MDIManager;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.ViewStack;
	import mx.controls.NumericStepper;
	import mx.core.mx_internal;
	import mx.effects.Effect;
	import mx.events.FlexEvent;
	import mx.events.NumericStepperEvent;
	import mx.events.ResizeEvent;
	
	use namespace mx_internal; 
	
	/**
	 * This class represents the windows Bar when they are minimized.
	 * @author mmarmol
	 * 
	 */
	public class MDIWindowsBar extends HBox
	{
		public static const windowsPadding : Number= 2;
		public var windowManager:MDIManager;
		public var minimizedWindows : ArrayCollection;
		public var barsContainer : ViewStack;
		private var barsNav : NumericStepper;
		
		private var minimizeAllArray:ArrayCollection = new ArrayCollection();
		
		/**
		 * Basic constructor.
		 * 
		 */
		public function MDIWindowsBar()
		{
			this.minimizedWindows = new ArrayCollection();
			this.percentWidth=100;
			this.percentHeight=100;
			
			this.barsContainer = new ViewStack();
			this.barsContainer.percentWidth=100;
			this.barsContainer.percentHeight=100;
			this.barsContainer.minWidth=Math.floor((MDIWindow.minSize+windowsPadding)*1.1);
			this.addChild(barsContainer);
			
			this.barsNav = new NumericStepper();
			this.barsNav.percentHeight=100;
			this.barsNav.width=0;
			this.barsNav.minimum=0;
			this.barsNav.stepSize=1;
			this.barsNav.setStyle('backgroundAlpha',0);
			this.barsNav.setStyle('borderStyle','none');
			this.barsNav.setStyle('cornerRadius',null);
			this.barsNav.addEventListener(FlexEvent.CREATION_COMPLETE,setEditableFalse);
			this.barsNav.addEventListener(NumericStepperEvent.CHANGE,setContainerView);
			this.addChild(this.barsNav);

			this.barsContainer.addEventListener(ResizeEvent.RESIZE,refreshWindows);
		}
		
		/**
		 * Add a window into the container. 
		 * @param window
		 * 
		 */
		public function addWindow(window:MDIWindow):void{
			this.minimizedWindows.addItem(window);
			window.isMinimized=true;
			
			if (this.minimizeAllArray.contains(window)){
				this.minimizeAllArray.removeItemAt(this.minimizeAllArray.getItemIndex(window));
				if (this.minimizeAllArray.length<1){
					refreshWindows();
				}
			}
			else{
				refreshWindows();
			}	
		}
		
		/**
		 * Removes the window from the container. 
		 * @param window
		 * 
		 */
		public function removeWindow(window:MDIWindow):void{
			this.minimizedWindows.removeItemAt(this.minimizedWindows.getItemIndex(window));
			window.isMinimized=false;
			if (this.minimizeAllArray.length<1){
				refreshWindows();	
			}
		}
		
		/**
		 * Refresh the windows states and visual inside the container when minimized. 
		 * @param event
		 * 
		 */
		private function refreshWindows(event:ResizeEvent=null):void{
			var windowsByContainer : Number = Math.floor(this.barsContainer.width/(MDIWindow.minSize+2*windowsPadding));
			var containersRequiered : Number = Math.ceil(this.minimizedWindows.length/windowsByContainer);
			var windowsAdded : Number = 0;
			var container : HBox;
			
			if (containersRequiered == 0){
				containersRequiered = 1;
			}
			
			this.barsContainer.removeAllChildren();
			
			for (var containerNumber : Number = 0; containerNumber < containersRequiered; containerNumber++){
				container = new HBox();
				container.setStyle('horizontalGap',windowsPadding);
				container.setStyle('verticalAlign','middle');
				this.barsContainer.addChild(container);
				for (var windowNumber : Number = 0; windowNumber < windowsByContainer && windowsAdded<this.minimizedWindows.length; windowNumber++){
					container.addChild(MDIWindow(this.minimizedWindows.getItemAt(windowsAdded)));
					windowsAdded++;
				}
			}
			
			this.barsNav.value=0;
			this.barsNav.maximum=containersRequiered-1;
			if (containerNumber>1){
				this.barsNav.visible=true;
			}
			else{
				this.barsNav.visible=false;
			}
		}
		
		private function setEditableFalse(event:FlexEvent):void{
			this.barsNav.mx_internal::inputField.editable = false;
		}
		
		private function setContainerView(event:NumericStepperEvent):void{
			var containerOld : HBox;
			var container : HBox;
			var effect:Effect;
			/*we use the oldcontainer because the realatives x and y are the same and we are sure that
			this one was allready added to stage*/
			containerOld = container = this.barsContainer.getChildAt(this.barsContainer.selectedIndex) as HBox;
			containerOld.endEffectsStarted();
			if (this.barsContainer.selectedIndex > this.barsNav.value){
				container = this.barsContainer.getChildAt(this.barsNav.value) as HBox;
				container.setStyle("showEffect",this.windowManager.effects.getTitledContainerDownEffect(containerOld));
			}
			else{
				container = this.barsContainer.getChildAt(this.barsNav.value) as HBox;
				container.setStyle("showEffect",this.windowManager.effects.getTitledContainerUpEffect(containerOld));			
			}
			this.barsContainer.selectedIndex = this.barsNav.value;

		}

		/**
		 * All the minimized windows. 
		 * @param value
		 * 
		 */
		public function minimizeAll(value:Array):void{
			this.minimizeAllArray = new ArrayCollection(this.minimizeAllArray.source.concat(value));
		}

	}
}