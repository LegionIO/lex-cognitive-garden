# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Runners::CognitiveGarden do
  let(:runner) do
    obj = Object.new
    obj.extend(described_class)
    obj
  end

  let(:engine) { Legion::Extensions::CognitiveGarden::Helpers::GardenEngine.new }

  describe '#plant_seed' do
    it 'returns success' do
      result = runner.plant_seed(plant_type: :idea, domain: :reasoning,
                                 content: 'test', engine: engine)
      expect(result[:success]).to be true
      expect(result[:plant][:plant_type]).to eq(:idea)
    end

    it 'returns failure for invalid type' do
      result = runner.plant_seed(plant_type: :weed, domain: :t, content: 'x', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '#create_plot' do
    it 'returns success' do
      result = runner.create_plot(engine: engine)
      expect(result[:success]).to be true
      expect(result[:plot]).to be_a(Hash)
    end
  end

  describe '#grow' do
    it 'grows a plant' do
      p = engine.plant_seed(plant_type: :idea, domain: :t, content: 'x')
      result = runner.grow(plant_id: p.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:plant][:health]).to be > 0.5
    end
  end

  describe '#water' do
    it 'waters a plant' do
      p = engine.plant_seed(plant_type: :idea, domain: :t, content: 'x')
      result = runner.water(plant_id: p.id, engine: engine)
      expect(result[:success]).to be true
    end
  end

  describe '#list_plants' do
    before do
      engine.plant_seed(plant_type: :idea, domain: :t, content: 'a')
      engine.plant_seed(plant_type: :theory, domain: :t, content: 'b')
    end

    it 'returns all plants' do
      result = runner.list_plants(engine: engine)
      expect(result[:count]).to eq(2)
    end

    it 'filters by type' do
      result = runner.list_plants(plant_type: :idea, engine: engine)
      expect(result[:count]).to eq(1)
    end
  end

  describe '#garden_status' do
    it 'returns report' do
      result = runner.garden_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to include(:total_plants)
    end
  end
end
