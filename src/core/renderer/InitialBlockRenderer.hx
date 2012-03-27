/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package core.renderer;
import cocktail.Lib;
import core.nativeElement.NativeElement;
import core.geom.GeomData;
import core.Style;
import core.Window;
import haxe.Log;

/**
 * This is the ElementRenderer generated by a BodyDOMElement
 * 
 * @author Yannick DOMINGUEZ
 */
class InitialBlockRenderer extends BlockBoxRenderer
{
	/**
	 * class constructor. Set the viewport as the bounds
	 * of the ElementRenderer, as a BodyDOMElement
	 * always covers all of the viewport
	 */
	public function new(style:Style) 
	{
		super(style);
		
		
		var width:Float = Lib.window.innerWidth;
		var height:Float = Lib.window.innerHeight;
		
		_bounds.width = width;
		_bounds.height = height;
	}
	
	override public function isInitialContainer():Bool
	{
		return true;
	}
	
	/**
	 * Render and position the background color and
	 * image of the element using runtime specific
	 * API and return an array of NativeElement from
	 * it
	 */
	override public function renderBackground():Array<NativeElement>
	{
		Log.trace(_bounds);
		var backgrounds:Array<NativeElement> = _backgroundManager.render(_bounds, _style);
		
		for (i in 0...backgrounds.length)
		{
			#if (flash9 || nme)
			backgrounds[i].x = _bounds.x;
			backgrounds[i].y = _bounds.y;
			#end
		}
		
	
		return backgrounds;
	}
	
}