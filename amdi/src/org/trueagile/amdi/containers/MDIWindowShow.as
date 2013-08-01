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
	import com.dougmccune.containers.BasePV3DContainer;
	import com.dougmccune.containers.CarouselContainer;
	import com.dougmccune.containers.CoverFlowContainer;
	import com.dougmccune.containers.VCoverFlowContainer;
	import com.dougmccune.containers.VistaFlowContainer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	/**
	 * This class manage the windows show in the msi application. 
	 * @author mmarmol
	 * 
	 */
	internal class MDIWindowShow
	{
		private var vistaFlow:BasePV3DContainer;
		
		private var amdi:MDIApplication;
		
		private var windows:Array;
		
		public var maxWidth:Number = 400;
		
		public var maxHeight:Number = 400;

		public var actualStyle:String = MDIApplication.CAROUSEL_CONTAINER;
		
		/**
		 * Basic Constructor. 
		 * @param app
		 * 
		 */
		public function MDIWindowShow(app:MDIApplication)
		{
			this.amdi=app;
			this.changeStyle(MDIApplication.CAROUSEL_CONTAINER);
		}

		/**
		 * Changes the style of the minimized windows. 
		 * @param newStyle
		 * 
		 */
		public function changeStyle(newStyle:String):void{
			if (newStyle==MDIApplication.CAROUSEL_CONTAINER){
				vistaFlow = new CarouselContainer();
			} else if (newStyle==MDIApplication.COVER_FLOW_CONTAINER){
				vistaFlow = new CoverFlowContainer();
			} else if (newStyle==MDIApplication.VCOVER_FLOW_CONTAINER){
				vistaFlow = new VCoverFlowContainer();
			} else if (newStyle==MDIApplication.VISTA_FLOW_CONTAINER){
				vistaFlow = new VistaFlowContainer();
			} else {
				return;
			}
			actualStyle = newStyle;
            vistaFlow.reflectionEnabled = true;
            vistaFlow.addEventListener(Event.CHANGE, handleVistaChange);
		}

           private function showVistaFlow():void {
                windows = amdi.windowManager.getOpenWindowList().concat(amdi.windowManager.getTiledWindows());
                var n:int = windows.length;
                var windowWidth:Number = 0;
                var windowHeight:Number = 0;
				var selectedIndex:int=0;
                
                if (windows.length<1){
                	return;
                }
                
                vistaFlow.removeAllChildren();
                    
                for(var i:int=0; i<n; i++) {
                    var window:MDIWindow = windows[i];
                    
                    var bitmap:Bitmap;
                    var ratio:Number;
					if (window.isMinimized){
						windowWidth=window.savedWindowRect.width;
						windowHeight=window.savedWindowRect.height;
					}
					else {
						windowWidth=window.width;
						windowHeight=window.height;
					}
                    if(windowWidth > maxWidth || windowHeight > maxHeight) {
                        if(windowWidth > windowHeight) {
                            ratio = maxWidth/windowWidth;
                        }
                        else {
                            ratio = maxHeight/windowHeight;
                        }
                    }
                    else {
                        ratio = 1;
                    }	
                    
                    var container:Container = new Container();
                    var uiComp:UIComponent = new UIComponent();
                    
                    if(window.hasFocus) {
                        selectedIndex = i;
                    }

                    window.validateNow();
                    
                    var matrix:Matrix = new Matrix();
                    matrix.scale(ratio, ratio);

                    var bmapData:BitmapData = new BitmapData(windowWidth*ratio, windowHeight*ratio, true, 0x00000000);
                    if (window.isMinimized){
                    	bmapData.draw(window.bitmapDataBefore, matrix, null, null, null, true);
                    }
                    else {
                    	bmapData.draw(window, matrix, null, null, null, true);
                    }
                    bitmap = new Bitmap(bmapData, PixelSnapping.AUTO, true);    
                    
                    uiComp.addChild(bitmap);
                    container.addChild(uiComp);
                    
                    container.width = uiComp.width= windowWidth*ratio;
                    container.height = uiComp.height = windowHeight*ratio;
                    
                    vistaFlow.addChild(container);
                }
                
                vistaFlow.selectedIndex = selectedIndex;
                
                vistaFlow.width = amdi.width;
                vistaFlow.height = amdi.height;
                PopUpManager.addPopUp(vistaFlow, this.amdi, true);
            }
            
            private function removeVistaFlow():void {
                
                var selectedIndex:int = vistaFlow.selectedIndex;
                var window:MDIWindow = windows[selectedIndex];
                
                if (window.isMinimized){
                	window.unMinimize();
                }else{
                	amdi.windowManager.bringToFront(windows[selectedIndex]);
                }
                vistaFlow.removeAllChildren();
                PopUpManager.removePopUp(vistaFlow);
            }
         
           private function handleVistaChange(event:Event):void {
                var index:int = vistaFlow.selectedIndex;
                amdi.windowManager.bringToFront(amdi.windowManager.getOpenWindowList()[index]);
            }
            
            /**
             * Add the keyboard listeners. 
             * 
             */
            public function addKeyboardListeners():void {
                ((this.amdi) as DisplayObject).stage.addEventListener(KeyboardEvent.KEY_DOWN, vistaKeyDownHandler);
                ((this.amdi) as DisplayObject).stage.addEventListener(KeyboardEvent.KEY_UP, vistaKeyUpHandler);
            }

            /**
             * Remove the keyboard listeners. 
             * 
             */            
			public function removeKeyboardListeners():void {
                ((this.amdi) as DisplayObject).stage.removeEventListener(KeyboardEvent.KEY_DOWN,vistaKeyDownHandler);
                ((this.amdi) as DisplayObject).stage.removeEventListener(KeyboardEvent.KEY_UP, vistaKeyUpHandler);				
			}
            
            private function vistaKeyDownHandler(event:KeyboardEvent):void {
                if(event.shiftKey && event.keyCode == Keyboard.ENTER) {
                    if(vistaFlow && vistaFlow.isPopUp) {
                        if(vistaFlow.selectedIndex < vistaFlow.numChildren - 1) {
                            vistaFlow.selectedIndex++;
                        }
                        else {
                            vistaFlow.selectedIndex = 0;
                        }
                    }
                    else {
                        showVistaFlow();
                    }
                }
            }
            
            private function vistaKeyUpHandler(event:KeyboardEvent):void {
                if(vistaFlow && vistaFlow.isPopUp && event.keyCode == Keyboard.SHIFT) {
                    removeVistaFlow();    
                }
            }

	}
}