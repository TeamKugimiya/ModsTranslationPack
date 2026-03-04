---
navigation:
  title: Ender Shard
  icon: simpleteleporters:ender_shard
  parent: index.md
  position: 2
item_ids:
  - simpleteleporters:ender_shard
---

# Ender Shard

<Row>
<Column>

The Ender Shard is the key component for linking <ItemLink id="simpleteleporters:teleporter" /> blocks together.

<ItemImage id="simpleteleporters:ender_shard" scale="4" />

</Column>
<Column>

## Recipe

<Recipe id="simpleteleporters:ender_shard" />

</Column>
</Row>

## How to Use

### Linking to a Location

1. Hold the Ender Shard in your hand
2. **Sneak** and **right-click** on a block to bind the shard to that location
3. The shard will remember the exact coordinates and dimension

### Tooltip Information

- **Unlinked shards** display "Unlinked" in red with instructions on how to link
- **Linked shards** show the exact X, Y, Z coordinates and dimension they're bound to

## Features

- **Stackable**: Up to 16 Ender Shards can stack together (unlinked only - linked shards with different coordinates won't stack)
- **Smart Positioning**: When linking:
  - Clicking on a non-solid block binds to that exact position
  - Clicking on a Teleporter binds to one block above it (so you land on top)
  - Otherwise, binds to the clicked face of the block

## Upgrading

Ender Shards can only teleport within the same dimension. To enable **cross-dimensional teleportation**, upgrade your Ender Shard to an <ItemLink id="simpleteleporters:enhanced_ender_shard" /> at a Smithing Table using an Echo Shard.

The linked position is preserved during the upgrade!

## Tips

- Keep spare unlinked Ender Shards for quickly setting up new teleport destinations
- The coordinates shown in the tooltip help you identify where each shard leads
- To change a shard's destination, simply sneak + right-click on a new location
