# lex-cognitive-garden

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-garden`

## Purpose

Models the cultivation of cognitive seeds into mature conceptual plants. Seeds are planted into a store, then sown into plots (bounded growing areas). Plants grow via explicit `grow` calls, wilt passively over time if not watered, and can pollinate each other to propagate traits. The garden metaphor maps cognitive nurturing: ideas need tending to survive and bloom.

## Gem Info

| Field | Value |
|---|---|
| Gem name | `lex-cognitive-garden` |
| Version | `0.1.0` |
| Namespace | `Legion::Extensions::CognitiveGarden` |
| Ruby | `>= 3.4` |
| License | MIT |
| GitHub | https://github.com/LegionIO/lex-cognitive-garden |

## File Structure

```
lib/legion/extensions/cognitive_garden/
  cognitive_garden.rb               # Top-level require
  version.rb                        # VERSION = '0.1.0'
  client.rb                         # Client class
  helpers/
    constants.rb                    # Plant/soil types, growth stages, rates, labels
    plant.rb                        # Plant value object
    plot.rb                         # Plot value object (bounded growing space)
    garden_engine.rb                # Engine: seeds, plots, growth, wilting, pollination
  runners/
    cognitive_garden.rb             # Runner module (extend self)
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `PLANT_TYPES` | array | `[:concept, :theory, :belief, :memory, :intention, :insight, :intuition, :fantasy]` |
| `GROWTH_STAGES` | array | `[:seed, :sprout, :sapling, :mature, :flowering, :fruiting, :dormant, :wilted]` |
| `SOIL_TYPES` | array | `[:fertile, :rocky, :sandy, :clay, :loamy, :hydroponic]` |
| `MAX_PLANTS` | 500 | Plant store cap |
| `MAX_PLOTS` | 50 | Plot cap |
| `GROWTH_RATE` | 0.05 | Growth increment per `grow` call |
| `WILT_RATE` | 0.03 | Health decrease per `wilt_all!` call |
| `HEALTH_LABELS` | hash | `thriving` (0.8+) through `dying` |
| `FERTILITY_LABELS` | hash | `rich` (0.8+) through `barren` |

## Helpers

### `Plant`

A cognitive seed or growing idea.

- `initialize(plant_type:, domain:, content:, health: 1.0, growth: 0.0, plant_id: nil)`
- `grow!(rate)` — increases growth, advances stage
- `water!(amount)` — restores health
- `wilt!(rate)` — decreases health
- `wilted?`, `mature?`, `flowering?`
- `growth_stage` — derived from current growth level
- `to_h`

### `Plot`

A bounded growing space within the garden.

- `initialize(capacity: 10, soil_type: :fertile, plot_id: nil)`
- `sow(plant_id)` — adds plant to plot; returns error if at capacity
- `fertility` — derived from soil type
- `to_h`

### `GardenEngine`

- `plant_seed(plant_type:, domain:, content:, health: 1.0)` — creates Plant, stores in seed map; returns `{ planted:, plant_id:, plant: }` or capacity error
- `create_plot(capacity: 10, soil_type: :fertile)` — returns `{ created:, plot_id:, plot: }` or capacity error
- `sow(plant_id:, plot_id:)` — validates both exist, assigns plant to plot
- `grow_plant(plant_id:)` — applies `GROWTH_RATE` to specified plant
- `water_plant(plant_id:, amount: 0.2)` — restores plant health
- `wilt_all!` — decrements health of all plants by `WILT_RATE`
- `grow_all!` — increments growth of all non-wilted plants
- `pollinate(source_id:, target_id:)` — transfers traits between plants
- `healthiest_plants(limit: 10)`, `most_mature(limit: 10)`
- `garden_report` — full stats including plant count, plot count, stage distribution

## Runners

**Module**: `Legion::Extensions::CognitiveGarden::Runners::CognitiveGarden`

Uses `extend self` pattern.

| Method | Key Args | Returns |
|---|---|---|
| `plant_seed` | `plant_type:`, `domain:`, `content:`, `health: 1.0` | `{ success:, plant_id:, plant: }` |
| `create_plot` | `capacity: 10`, `soil_type: :fertile` | `{ success:, plot_id:, plot: }` |
| `grow` | `plant_id:` | `{ success:, plant: }` |
| `water` | `plant_id:`, `amount: 0.2` | `{ success:, plant: }` |
| `list_plants` | `limit: 50` | `{ success:, plants:, total: }` |
| `garden_status` | — | `{ success:, report: }` |

Private: `garden(engine)` — memoized `GardenEngine`. Logs via `log_debug` helper with `defined?(Legion::Logging)` guard.

## Integration Points

- **`lex-cognitive-genesis`**: Garden plants represent early-stage concepts. Mature, flowering plants are candidates for genesis seed germination. The garden feeds the concept lifecycle pipeline.
- **`lex-cognitive-furnace`**: Harvested fruits from mature garden plants can serve as ore inputs for furnace smelting. A mature insight plant produces ore that can be refined into wisdom.
- **`lex-memory`**: Plant growth milestones (mature, flowering) can be stored as semantic traces in lex-memory with domain tagging.

## Development Notes

- `wilt_all!` and `grow_all!` are batch operations that affect every plant in the store, regardless of plot assignment. Unplanted seeds also wilt.
- Wilted plants (`health <= 0.0`) remain in the store; callers must check `wilted?` and prune manually.
- `pollinate` copies traits from source to target but does not remove source traits.
- In-memory only.

---

**Maintained By**: Matthew Iverson (@Esity)
