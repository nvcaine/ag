package model.dto;

class ProjectileDTO extends AbstractDTO
{
	public var type:String;
	public var damage:Int;
	public var width:Int;
	public var height:Int;
	public var assetPath:String;
	public var sound:String;
	public var speed:Float = 0;
	public var fadeRate:Float = 0;
}