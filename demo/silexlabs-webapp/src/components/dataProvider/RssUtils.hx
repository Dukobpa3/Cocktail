/*
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/

package components.dataProvider;

/**
 * This class contains Rss utils
 * 
 * @author Raphael Harmel
 */

import cocktail.domElement.ContainerDOMElement;
import cocktail.domElement.ImageDOMElement;
import cocktail.nativeElement.NativeElementManager;
import cocktail.nativeElement.NativeElementData;
//import cocktail.textElement.TextElement;

import components.richList.RichListModels;
import components.richList.ContainerRichListModels;
import components.richList.ContainerRichListUtils;

class RssUtils 
{
	
	/**
	 * Converts a rss to an Array of ContainerCellModels
	 * 
	 * @param	rss
	 * @return
	 */
	//public static function rss2ContainerCells(rss:Xml):Array<ContainerCellModel>
	public static function rss2ContainerCells(rss:Xml):ContainerRichListModel
	{
		//var cells:Array<ContainerCellModel> = new Array<ContainerCellModel>();
		var cells:ContainerRichListModel = ContainerRichListUtils.createContainerRichListModel();

		// set channel node
		var channelNode:Xml = rss.firstElement().firstElement();
		
		// create the "ul" container
		//var cellsContainer:ContainerDOMElement = new ContainerDOMElement(NativeElementManager.createNativeElement(NativeElementTypeValue.custom("ul")));
				
		// get the rss data
		for ( channelChild in channelNode.elements() )
		{
			if (channelChild.nodeName == "item")
			{
				// create cellContent as "li" container
				var cellContent:ContainerDOMElement = new ContainerDOMElement(NativeElementManager.createNativeElement(NativeElementTypeValue.custom("li")));
				
				// create cellContainer which contains the cellContent
				var cell:ContainerCellModel = { content: cellContent, action:"", actionTarget:"" };

				// for each node
				for (itemParam in channelChild.elements())
				{
					// Silex Labs feed
					// if node is a thumb image
					if (itemParam.nodeName == "post_thumbnail")
					{
						var image:ImageDOMElement = new ImageDOMElement();
						// set image style
						//listStyle.cellImage(image);
						// add image
						cellContent.addChild(image);
						// load image
						image.load(itemParam.firstChild().nodeValue);
					}
					// if node is a title
					if (itemParam.nodeName == "post_title")
					{
						// create container
						var titleContainer:ContainerDOMElement = Utils.getTextContainer(itemParam.firstChild().nodeValue);
						// apply style
						//listStyle.cellText(titleContainer);
						// add container to cellcontent
						cellContent.addChild(titleContainer);
					}
					// if node is a date
					if (itemParam.nodeName == "post_date_gmt")
					{
						// create text
						var text:String = "on " + itemParam.firstChild().nodeValue;
						// create container
						var dateContainer:ContainerDOMElement = Utils.getTextContainer(text);
						// apply style
						//listStyle.cellText(dateContainer);
						// add container to cellcontent
						cellContent.addChild(dateContainer);
					}
					// if node is a post content - removed as can contain html
					/*if (itemParam.nodeName == "post_content")
					{
						// create text
						var text:String = (itemParam.firstChild().nodeValue).substr(0, 100) + "...";
						// create container
						var dateContainer:ContainerDOMElement = Utils.getTextContainer(text);
						// apply style
						//listStyle.cellText(dateContainer);
						// add container to cellcontent
						cellContent.addChild(dateContainer);
					}*/
					// if node is the link to be opened
					if (itemParam.nodeName == "guid")
					{
						// create container
						var linkContainer:ContainerDOMElement = Utils.getTextContainer(itemParam.firstChild().nodeValue);
						// apply style
						//listStyle.cellText(titleContainer);
						// add container to cellcontent
						cellContent.addChild(linkContainer);
					}
					// if node is a author info
					if (itemParam.nodeName == "post_author")
					{
						for (authorInfo in itemParam.elements())
						{
							if (authorInfo.nodeName == "nickname")
							{
								// create text
								var text:String = "Posted by " + authorInfo.firstChild().nodeValue;
								// create container
								var nicknameContainer:ContainerDOMElement = Utils.getTextContainer(text);
								// apply style
								//listStyle.cellText(dateContainer);
								// add container to cellcontent
								cellContent.addChild(nicknameContainer);
							}
						}
					}
					// FTV feed
					// if node is a title
					/*if (itemParam.nodeName == "title")
					{
						cell.text = itemParam.firstChild().nodeValue;
					}
					// if node is a thumb image
					else if (itemParam.nodeName == "enclosure")
					{
						cell.imagePath = itemParam.get("url");
					}*/
					
					// flikr feed
					// if node is a title
					/*if (itemParam.nodeName == "media:title")
					{
						cell.text = itemParam.firstChild().nodeValue;
					}
					// if node is a thumb image
					//if (itemParam.nodeName == "media:thumbnail")
					else if (itemParam.nodeName == "media:content")
					{
						cell.imagePath = itemParam.get("url");
					}*/
				}
				cell.content = cellContent;
				cells.push(cell);
				//cellsContainer.addChild(cellContainer);
			}
		}
		return cells;
	}

	/**
	 * Converts a rss to an Array of CellModels
	 * 
	 * @param	rss
	 * @return
	 */
	//public static function rss2Cells(rss:Xml):Array<CellModel>
	public static function rss2Cells(rss:Xml):Array<DynamicCellModel>
	{
		var cells:Array<DynamicCellModel> = new Array<DynamicCellModel>();

		// set channel node
		var channelNode:Xml = rss.firstElement().firstElement();
		
		// get the rss data
		for ( channelChild in channelNode.elements() )
		{
			if (channelChild.nodeName == "item")
			{
				//var cell:CellModel = { text:"", imagePath:"", action:"openUrl", actionTarget:"http://www.google.com/" };
				var cell:DynamicCellModel = { content:null, action:"openUrl", actionTarget:"http://www.google.com/" };
				var cellContent:Dynamic = { imagePath:"", title:"", comment:"Posted " };
				
				// for each node
				for (itemParam in channelChild.elements())
				{
					// Silex Labs feed
					
					// if node is a thumbnail image
					if (itemParam.nodeName == "post_thumbnail")
					{
						cellContent.thumbnail = itemParam.firstChild().nodeValue;
					}
					// if node is a title
					if (itemParam.nodeName == "post_title")
					{
						cellContent.title = itemParam.firstChild().nodeValue;
					}
					// if node is a author info
					if (itemParam.nodeName == "post_author")
					{
						for (authorInfo in itemParam.elements())
						{
							if (authorInfo.nodeName == "nickname")
							{
								cellContent.comment = cellContent.comment  + "by " + authorInfo.firstChild().nodeValue + " ";
							}
						}
					}
					// if node is a date
					if (itemParam.nodeName == "post_date_gmt")
					{
						// create text
						cellContent.comment = cellContent.comment  + "on " + itemParam.firstChild().nodeValue + " ";
					}
					// if node is a post content - removed as can contain html
					/*if (itemParam.nodeName == "post_content")
					{
						// create text
						var text:String = (itemParam.firstChild().nodeValue).substr(0, 100) + "...";
						// create container
						var dateContainer:ContainerDOMElement = Utils.getTextContainer(text);
						// apply style
						//listStyle.cellText(dateContainer);
						// add container to cellcontent
						cellContent.addChild(dateContainer);
					}*/
					// if node is the link to be opened
					if (itemParam.nodeName == "guid")
					{
						cellContent.actionTarget = itemParam.firstChild().nodeValue;
					}
					// FTV feed
					// if node is a title
					/*if (itemParam.nodeName == "title")
					{
						cell.text = itemParam.firstChild().nodeValue;
					}
					// if node is a thumb image
					else if (itemParam.nodeName == "enclosure")
					{
						cell.imagePath = itemParam.get("url");
					}*/
					
					// flikr feed
					// if node is a title
					/*if (itemParam.nodeName == "media:title")
					{
						cell.text = itemParam.firstChild().nodeValue;
					}
					// if node is a thumb image
					//if (itemParam.nodeName == "media:thumbnail")
					else if (itemParam.nodeName == "media:content")
					{
						cell.imagePath = itemParam.get("url");
					}*/
				}
				cell.content = cellContent;
				cells.push(cell);
			}
		}
		return cells;
	}
	
}
