package model.dto;

class WeaponDTO extends ItemDTO
{
	public var projectile:ProjectileDTO;
	public var energy:Int;
	public var damage:Int;
	public var fireDelay:Float;

	override public function getTooltipLabel():String
	{
		return name + "\nDPS: " + Math.round(damage / fireDelay);
	}
}