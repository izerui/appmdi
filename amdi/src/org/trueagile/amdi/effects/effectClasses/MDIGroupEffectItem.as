/*
Copyright (c) 2010, TRUEAGILE
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the TRUEAGILE nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.trueagile.amdi.effects.effectClasses
{
	import org.trueagile.amdi.containers.MDIWindow;
	
	import flash.geom.Point;
	
	public class MDIGroupEffectItem
	{		
		public var window:MDIWindow;
		public var moveTo:Point = new Point();
		
		public var widthFrom:Number = 0;
		public var widthTo:Number = 0;
		public var heightFrom:Number = 0;
		public var heightTo:Number = 0;
			
		public function MDIGroupEffectItem(window:MDIWindow):void
		{
			this.window = window;
		}
		
		public function setWindowSize():void
		{
			this.window.width = this.widthTo;
			this.window.height = this.heightTo;
		}
		
		public function get isCorrectSize():Boolean
		{
			return window.height == heightTo && window.width == widthTo;
		}
		
		public function get isCorrectPosition():Boolean
		{
			return window.x == moveTo.x && window.y == moveTo.y;
		}
		
		public function get isInPlace():Boolean
		{
			return isCorrectSize && isCorrectPosition;
		}		
	}
}