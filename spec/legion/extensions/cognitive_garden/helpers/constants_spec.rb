# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Helpers::Constants do
  described_class = Legion::Extensions::CognitiveGarden::Helpers::Constants

  describe 'PLANT_TYPES' do
    it 'contains expected types' do
      expect(described_class::PLANT_TYPES).to eq(%i[idea hypothesis theory skill habit])
    end
  end

  describe 'GROWTH_STAGES' do
    it 'contains expected stages' do
      expect(described_class::GROWTH_STAGES).to eq(%i[seed sprout sapling mature ancient])
    end
  end

  describe 'SOIL_TYPES' do
    it 'contains expected soils' do
      expect(described_class::SOIL_TYPES).to eq(%i[fertile loamy sandy clay rocky])
    end
  end

  describe '.label_for' do
    it 'returns :flourishing for high health' do
      expect(described_class.label_for(described_class::HEALTH_LABELS, 0.9)).to eq(:flourishing)
    end

    it 'returns :withered for low health' do
      expect(described_class.label_for(described_class::HEALTH_LABELS, 0.1)).to eq(:withered)
    end

    it 'returns :paradise for high fertility' do
      expect(described_class.label_for(described_class::FERTILITY_LABELS, 0.9)).to eq(:paradise)
    end

    it 'returns :barren for low fertility' do
      expect(described_class.label_for(described_class::FERTILITY_LABELS, 0.1)).to eq(:barren)
    end
  end
end
