package model.dto;

import nme.geom.Point;

class ItemDTO extends AbstractDTO
{
	public var type:String;
	public var name:String;
	/*public var attributes:Array<Dynamic>;*/
	public var offset:Point;
	public var assetPath:String; // icon
	public var layerAsset:String; // when mounted

	public var width:Int;
	public var height:Int;

	public function getTooltipLabel():String
	{
		return name;
	}
}