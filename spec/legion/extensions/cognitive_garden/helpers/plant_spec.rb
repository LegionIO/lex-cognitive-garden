# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Helpers::Plant do
  subject(:plant) do
    described_class.new(plant_type: :idea, domain: :reasoning, content: 'new concept')
  end

  describe '#initialize' do
    it 'assigns a UUID' do
      expect(plant.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'sets plant_type' do
      expect(plant.plant_type).to eq(:idea)
    end

    it 'defaults health to 0.5' do
      expect(plant.health).to eq(0.5)
    end

    it 'defaults water_level to 0.5' do
      expect(plant.water_level).to eq(0.5)
    end

    it 'sets initial stage based on health' do
      expect(plant.stage).to eq(:sapling)
    end

    it 'raises on unknown type' do
      expect do
        described_class.new(plant_type: :weed, domain: :t, content: 'x')
      end.to raise_error(ArgumentError, /unknown plant type/)
    end

    it 'sets seed stage for low health' do
      p = described_class.new(plant_type: :idea, domain: :t, content: 'x', health: 0.1)
      expect(p.stage).to eq(:seed)
    end
  end

  describe '#grow!' do
    it 'increases health' do
      initial = plant.health
      plant.grow!
      expect(plant.health).to be > initial
    end

    it 'decreases water level' do
      initial = plant.water_level
      plant.grow!
      expect(plant.water_level).to be < initial
    end

    it 'grows slower when thirsty' do
      well_watered = described_class.new(plant_type: :idea, domain: :t, content: 'x',
                                         health: 0.5, water_level: 0.8)
      thirsty = described_class.new(plant_type: :idea, domain: :t, content: 'x',
                                    health: 0.5, water_level: 0.1)
      well_watered.grow!
      thirsty.grow!
      expect(well_watered.health).to be > thirsty.health
    end

    it 'advances stage when health crosses thresholds' do
      p = described_class.new(plant_type: :idea, domain: :t, content: 'x', health: 0.68)
      p.grow!(rate: 0.05)
      expect(p.stage).to eq(:mature)
    end
  end

  describe '#water!' do
    it 'increases water level' do
      initial = plant.water_level
      plant.water!
      expect(plant.water_level).to be > initial
    end
  end

  describe '#wilt!' do
    it 'decreases health' do
      initial = plant.health
      plant.wilt!
      expect(plant.health).to be < initial
    end
  end

  describe '#pollinate!' do
    it 'increases health' do
      initial = plant.health
      plant.pollinate!
      expect(plant.health).to be > initial
    end
  end

  describe '#flourishing?' do
    it 'returns false at default' do
      expect(plant).not_to be_flourishing
    end

    it 'returns true at 0.8+' do
      plant.health = 0.85
      expect(plant).to be_flourishing
    end
  end

  describe '#withered?' do
    it 'returns false at default' do
      expect(plant).not_to be_withered
    end

    it 'returns true below 0.2' do
      plant.health = 0.1
      expect(plant).to be_withered
    end
  end

  describe '#thirsty?' do
    it 'returns false at default' do
      expect(plant).not_to be_thirsty
    end

    it 'returns true below 0.2' do
      plant.water_level = 0.1
      expect(plant).to be_thirsty
    end
  end

  describe '#mature?' do
    it 'returns false at default' do
      expect(plant).not_to be_mature
    end

    it 'returns true at mature stage' do
      plant.health = 0.75
      plant.grow!(rate: 0.0)
      expect(plant).to be_mature
    end
  end

  describe '#to_h' do
    it 'includes all expected keys' do
      expected = %i[id plant_type domain content health water_level stage
                    health_label flourishing withered thirsty planted_at]
      expect(plant.to_h.keys).to match_array(expected)
    end
  end
end
