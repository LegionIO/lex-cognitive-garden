# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Helpers::Plot do
  subject(:plot) { described_class.new }

  describe '#initialize' do
    it 'assigns a UUID' do
      expect(plot.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults soil_type to loamy' do
      expect(plot.soil_type).to eq(:loamy)
    end

    it 'sets fertility based on soil type' do
      fertile = described_class.new(soil_type: :fertile)
      rocky = described_class.new(soil_type: :rocky)
      expect(fertile.fertility).to be > rocky.fertility
    end

    it 'raises on unknown soil' do
      expect do
        described_class.new(soil_type: :lava)
      end.to raise_error(ArgumentError, /unknown soil type/)
    end
  end

  describe '#sow' do
    it 'adds plant id' do
      expect(plot.sow('p-1')).to eq(:sown)
      expect(plot.plant_ids).to include('p-1')
    end

    it 'returns :already_planted for duplicates' do
      plot.sow('p-1')
      expect(plot.sow('p-1')).to eq(:already_planted)
    end
  end

  describe '#uproot' do
    it 'removes plant id' do
      plot.sow('p-1')
      expect(plot.uproot('p-1')).to eq(:uprooted)
    end

    it 'returns :not_found for missing' do
      expect(plot.uproot('nope')).to eq(:not_found)
    end
  end

  describe '#fertilize!' do
    it 'increases fertility' do
      initial = plot.fertility
      plot.fertilize!
      expect(plot.fertility).to be > initial
    end
  end

  describe '#deplete!' do
    it 'decreases fertility' do
      initial = plot.fertility
      plot.deplete!
      expect(plot.fertility).to be < initial
    end
  end

  describe '#paradise?' do
    it 'returns true for fertile soil' do
      p = described_class.new(soil_type: :fertile)
      expect(p).to be_paradise
    end
  end

  describe '#barren?' do
    it 'returns false at default' do
      expect(plot).not_to be_barren
    end

    it 'returns true below 0.2' do
      plot.fertility = 0.1
      expect(plot).to be_barren
    end
  end

  describe '#to_h' do
    it 'includes all expected keys' do
      expected = %i[id soil_type fertility sunlight fertility_label
                    plant_count paradise barren created_at]
      expect(plot.to_h.keys).to match_array(expected)
    end
  end
end
