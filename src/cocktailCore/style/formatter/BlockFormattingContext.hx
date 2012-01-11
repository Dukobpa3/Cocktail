/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktailCore.style.formatter;
import cocktail.domElement.ContainerDOMElement;
import cocktail.domElement.DOMElement;
import cocktail.style.StyleData;
import haxe.Log;

/**
 * This formatting context layout DOMElement below each other
 * following the DOM tree order.
 * 
 * @author Yannick DOMINGUEZ
 */
class BlockFormattingContext extends FormattingContext
{

	/**
	 * class constructor
	 */
	public function new(domElement:DOMElement, previousFormattingContext:FormattingContext) 
	{
		super(domElement, previousFormattingContext);
	}
	
	/**
	 * Place the DOMElement below the preceding DOMElement
	 */
	override private function place(domElement:DOMElement, parentDOMElement:DOMElement, position:Bool):Void
	{
		super.place(domElement, parentDOMElement, position);
		
		//add the left float offset if the element is embedded
		//(for instance an image), for non-embedded DOMElement
		//(like a container), the left float offset isn't used
		var leftFloatOffset:Int = 0;
		if (domElement.style.isEmbedded() == true)
		{
			_flowData.y = _floatsManager.getFirstAvailableY(flowData, domElement.offsetWidth, _containingDOMElementWidth);
			leftFloatOffset = _floatsManager.getLeftFloatOffset(_flowData.y  + domElement.style.computedStyle.marginTop);
		}
			
		//apply the new x and y position to the DOMElement and flowData
		_flowData.x = _flowData.xOffset + leftFloatOffset;
		
		
		
		
		var childTemporaryPositionData:ChildTemporaryPositionData = getChildTemporaryPositionData(domElement, _flowData.x, _flowData.y, 0, position);
		
		getChildrenTemporaryPositionData(parentDOMElement).push(childTemporaryPositionData);
		
		if (position == true)
		{
			_flowData.y += domElement.offsetHeight ;
			_flowData.totalHeight = _flowData.y  ;
		}
		
		
		//check if the offsetWidth of the DOMElement is the largest thus far. This metrics is used when the width
		//of a container is set as 'shrink-to-fit' (takes its content width)
		if (_flowData.x + domElement.offsetWidth + domElement.style.computedStyle.marginLeft > _flowData.maxWidth)
		{
			_flowData.maxWidth = _flowData.x + domElement.offsetWidth + domElement.style.computedStyle.marginLeft;
		}
		
	}

	/**
	 * clear left, right or both floats and set the y of the flowData below
	 * the last cleared float
	 */
	override public function clearFloat(clear:ClearStyleValue, isFloat:Bool):Void
	{
		_flowData.y = _floatsManager.clearFloat(clear, _flowData);
	}
	
	
	
	

	
}