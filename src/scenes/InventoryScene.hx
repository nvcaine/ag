package scenes;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import entities.inventory.EntityGrid;

import model.events.InventoryEvent;
import model.events.MenuEvent;

import nme.events.MouseEvent;

import org.events.EventManager;
import org.ui.Button;
import org.ui.TooltipButton;

class InventoryScene extends Scene
{
	private var backB:Button;
	private var em:EventManager;

	override public function begin()
	{
		backB = new Button(10, 10, {defaultImage: "gfx/menu/back.png", downImage: "gfx/menu/back_down.png", overImage: "gfx/menu/back_over.png"});

		backB.addListener(MouseEvent.CLICK, onBack);
		add(backB);

		drawShipTemplate();
		drawInventory();

		em = EventManager.cloneInstance();

		em.addEventListener(InventoryEvent.EQUIP_ITEM, onEquip);
	}

	override public function end()
	{
		backB.clearListener(MouseEvent.CLICK, onBack);
	}

	private function drawShipTemplate() // receive template data
	{
		var ship:Image = new Image("gfx/ship.png");
		var entity:Entity = new Entity(100, 150);

		ship.scaleX = ship.scaleY = 3;
		entity.graphic = ship;

		// add hard points dynamically
		add(entity);

		var hardpoint:TooltipButton = new TooltipButton(100, 200, {defaultImage:"gfx/hardpoint.png"});

		add(hardpoint);

		var hardpoint2:TooltipButton = new TooltipButton(200, 100, {defaultImage:"gfx/hardpoint.png"});

		add(hardpoint2);
	}

	private function drawInventory()
	{
		drawInventoryHeader();
	}

	private function drawInventoryHeader()
	{
		var weaponsButton:Button = new Button(5, 425, {defaultImage: "gfx/inventory/weapons.png", overImage: "gfx/inventory/weapons_hover.png", downImage: "gfx/inventory/weapons_down.png"});
		var enginesButton:Button = new Button(170, 425, {defaultImage: "gfx/inventory/engines.png", overImage: "gfx/inventory/engines_hover.png", downImage: "gfx/inventory/engines_down.png"});
		var utilityButton:Button = new Button(335, 425, {defaultImage: "gfx/inventory/utility.png", overImage: "gfx/inventory/utility_hover.png", downImage: "gfx/inventory/utility_down.png"});

		add(weaponsButton);
		add(enginesButton);
		add(utilityButton);

		var grid = new EntityGrid(this, 3, 5, 100, 100);
	}

	private function onBack(e:MouseEvent)
	{
		em.dispatchEvent(new MenuEvent(MenuEvent.SHOW_MENU));
	}

	private function onEquip(e:InventoryEvent)
	{
		trace("item equipped");
	}
}