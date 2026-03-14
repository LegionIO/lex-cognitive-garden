# lex-cognitive-garden

Cognitive cultivation engine for brain-modeled agentic AI in the LegionIO ecosystem.

## What It Does

Models the growth and decay of cognitive ideas as plants in a garden. Seeds (concepts, theories, beliefs, memories, intentions, insights) are planted into a seed store and sown into plots — bounded growing spaces with varying soil types. Plants grow through explicit `grow` calls and decay through passive wilting if left untended. Plants can pollinate each other to propagate traits. The garden captures the idea that cognitive content requires active nurturing to survive and mature.

## Usage

```ruby
require 'legion/extensions/cognitive_garden'

client = Legion::Extensions::CognitiveGarden::Client.new

# Plant a seed
result = client.plant_seed(plant_type: :insight, domain: :engineering, content: 'async task batching pattern')
plant_id = result[:plant_id]

# Create a plot with fertile soil
plot = client.create_plot(capacity: 10, soil_type: :fertile)
plot_id = plot[:plot_id]

# Tend the garden
client.grow(plant_id: plant_id)
# => { success: true, plant: { growth: 0.05, stage: :seed, ... } }

client.water(plant_id: plant_id, amount: 0.3)
# => { success: true, plant: { health: 1.0, ... } }

# Check garden state
client.garden_status
# => { success: true, report: { plant_count: 1, plot_count: 1, ... } }

# List active plants
client.list_plants(limit: 20)
# => { success: true, plants: [...], total: 1 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
