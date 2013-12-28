package model.proxy;

import model.consts.ProjectileTypeConsts;
import model.dto.ProjectileDTO;

class ProjectileProxy
{
	public var projectileTemplates:Array<ProjectileDTO>;

	private static var instance:ProjectileProxy;

	private function new()
	{
		projectileTemplates = [
			new ProjectileDTO({
				type: ProjectileTypeConsts.SIMPLE, assetPath: "gfx/glontz.png", sound: "sfx/laser.mp3",
				width: 6, height: 12, speed: 12.5
			}),

			new ProjectileDTO({
				type: ProjectileTypeConsts.SIMPLE, assetPath: "gfx/glontz2.png", sound: "sfx/laser1.mp3",
				width: 6, height: 15, speed: 12.5
			}),

			new ProjectileDTO({
				type: ProjectileTypeConsts.PLASMA, assetPath: "gfx/plasma2.png", sound: "sfx/laser.mp3",
				width: 19, height: 700, fadeRate: 0.01
			}),

			new ProjectileDTO({
				type: ProjectileTypeConsts.PLASMA, assetPath: "gfx/plasma3.png", sound: "sfx/laser.mp3",
				width: 19, height: 700, fadeRate: 0.01
			})
		];
	}

	public static function cloneInstance():ProjectileProxy
	{
		if(instance == null)
			instance = new ProjectileProxy();

		return instance;
	}
}