package entities.game.level;

import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;

import org.ui.TooltipButton;

class StageButton extends TooltipButton
{
	private var em:EventManager;
	private var data:Dynamic;

	public function new(data:Dynamic)
	{
		super(data.x, data.y, {defaultImage: data.asset});

		this.data = data;
	}

	override public function added()
	{
		em = EventManager.cloneInstance();

		setTooltipText(data.name);

		addListener(MouseEvent.CLICK, onClick);
	}

	override public function removed()
	{
		clearListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.NEW_GAME, data.levelIndex));
	}
}