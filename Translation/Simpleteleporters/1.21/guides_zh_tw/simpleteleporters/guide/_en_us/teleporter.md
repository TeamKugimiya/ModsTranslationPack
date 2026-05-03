---
navigation:
  title: Teleporter
  icon: simpleteleporters:teleporter
  parent: index.md
  position: 1
item_ids:
  - simpleteleporters:teleporter
---

# Teleporter

<Row>
<Column>

The Teleporter is a block that allows instant teleportation between linked locations.

<ItemImage id="simpleteleporters:teleporter" scale="4" />

</Column>
<Column>

## Recipe

<RecipeFor id="simpleteleporters:teleporter" />

</Column>
</Row>

## How to Use

### Setting Up a Teleporter

1. Place a Teleporter block at your destination
2. Bind an <ItemLink id="simpleteleporters:ender_shard" /> to a location above the destination teleporter by **sneaking** and **right-clicking** on it
3. Place another Teleporter block at your starting location
4. **Right-click** on the starting Teleporter with the linked Ender Shard to insert it

### Teleporting

Stand on an active Teleporter (one with portal particles) and **sneak** to teleport to the linked destination.

## Dyeing

Teleporters can be dyed any of the 16 vanilla colors to help organize your teleporter network. Simply **right-click** a Teleporter with any dye to change the color of its quartz base and platform. The default color is white.

This is purely cosmetic but useful for color-coding destinations (e.g., red for the Nether hub, blue for ocean bases).

## Redstone Activation

Teleporters can be activated with a **redstone signal**! When a teleporter receives a redstone pulse, it will teleport **all entities** standing on it to the linked destination - including players, mobs, animals, and items.

This enables powerful automation possibilities:
- Automatic mob farms that teleport mobs to a collection area
- Timed player transportation systems using redstone clocks
- Pressure plate triggers for hands-free teleportation
- Button-activated teleport stations

The teleporter only activates on the **rising edge** of a redstone signal (when it changes from unpowered to powered), preventing continuous teleportation from sustained signals.

## Features

- **Dyeable**: Right-click with any dye to customize the quartz base color
- **Redstone Activated**: Send a redstone signal to teleport all entities on the pad
- **Entity Teleportation**: Teleports players, mobs, animals, and more
- **Portal Particles**: Active Teleporters display portal particles when they have a linked Ender Shard
- **Cooldown**: A brief cooldown prevents instant re-teleportation
- **Waterloggable**: Can be placed underwater
- **Dimension Support**: Same dimension with Ender Shards, cross-dimensional with <ItemLink id="simpleteleporters:enhanced_ender_shard" />

## Tips

- For bidirectional travel, set up two Teleporters with Ender Shards pointing at each other
- The teleporter ejects the Ender Shard when you right-click it, allowing you to reconfigure your network
- If the destination is blocked, you'll receive an error message
