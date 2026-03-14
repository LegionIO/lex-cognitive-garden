# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Client do
  subject(:client) { described_class.new }

  it 'includes the runner module' do
    expect(described_class.ancestors).to include(
      Legion::Extensions::CognitiveGarden::Runners::CognitiveGarden
    )
  end

  it 'responds to plant_seed' do
    expect(client).to respond_to(:plant_seed)
  end

  it 'responds to grow' do
    expect(client).to respond_to(:grow)
  end

  it 'responds to water' do
    expect(client).to respond_to(:water)
  end

  it 'responds to garden_status' do
    expect(client).to respond_to(:garden_status)
  end

  it 'can plant and grow through client' do
    result = client.plant_seed(plant_type: :idea, domain: :test, content: 'seedling')
    expect(result[:success]).to be true
    grow_result = client.grow(plant_id: result[:plant][:id])
    expect(grow_result[:success]).to be true
  end
end
