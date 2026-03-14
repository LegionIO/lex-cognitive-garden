# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveGarden::Helpers::GardenEngine do
  subject(:engine) { described_class.new }

  let(:default_attrs) { { plant_type: :idea, domain: :reasoning, content: 'concept' } }

  describe '#plant_seed' do
    it 'creates and stores a plant' do
      p = engine.plant_seed(**default_attrs)
      expect(p).to be_a(Legion::Extensions::CognitiveGarden::Helpers::Plant)
      expect(engine.all_plants.size).to eq(1)
    end

    it 'raises when limit reached' do
      stub_const('Legion::Extensions::CognitiveGarden::Helpers::Constants::MAX_PLANTS', 1)
      engine.plant_seed(**default_attrs)
      expect do
        engine.plant_seed(plant_type: :theory, domain: :t, content: 'x')
      end.to raise_error(ArgumentError, /plant limit/)
    end
  end

  describe '#create_plot' do
    it 'creates and stores a plot' do
      plot = engine.create_plot
      expect(plot).to be_a(Legion::Extensions::CognitiveGarden::Helpers::Plot)
    end
  end

  describe '#sow' do
    it 'links plant to plot' do
      p = engine.plant_seed(**default_attrs)
      plot = engine.create_plot
      expect(engine.sow(plant_id: p.id, plot_id: plot.id)).to eq(:sown)
    end
  end

  describe '#grow_plant' do
    it 'grows a specific plant' do
      p = engine.plant_seed(**default_attrs)
      initial = p.health
      engine.grow_plant(plant_id: p.id)
      expect(p.health).to be > initial
    end
  end

  describe '#water_plant' do
    it 'waters a specific plant' do
      p = engine.plant_seed(**default_attrs)
      initial = p.water_level
      engine.water_plant(plant_id: p.id)
      expect(p.water_level).to be > initial
    end
  end

  describe '#pollinate' do
    it 'boosts both plants' do
      a = engine.plant_seed(**default_attrs)
      b = engine.plant_seed(plant_type: :theory, domain: :t, content: 'y')
      a_health = a.health
      b_health = b.health
      engine.pollinate(plant_a_id: a.id, plant_b_id: b.id)
      expect(a.health).to be > a_health
      expect(b.health).to be > b_health
    end
  end

  describe '#wilt_all!' do
    it 'wilts all plants' do
      p = engine.plant_seed(**default_attrs)
      initial = p.health
      engine.wilt_all!
      expect(p.health).to be < initial
    end
  end

  describe '#grow_all!' do
    it 'grows all plants' do
      p = engine.plant_seed(**default_attrs)
      initial = p.health
      engine.grow_all!
      expect(p.health).to be > initial
    end
  end

  describe '#plants_by_type' do
    it 'returns counts per type' do
      engine.plant_seed(**default_attrs)
      engine.plant_seed(plant_type: :theory, domain: :t, content: 'x')
      counts = engine.plants_by_type
      expect(counts[:idea]).to eq(1)
      expect(counts[:theory]).to eq(1)
    end
  end

  describe '#healthiest' do
    it 'returns sorted by health desc' do
      engine.plant_seed(**default_attrs, health: 0.3)
      p2 = engine.plant_seed(plant_type: :theory, domain: :t, content: 'x', health: 0.9)
      expect(engine.healthiest(limit: 1).first).to eq(p2)
    end
  end

  describe '#garden_report' do
    it 'returns comprehensive hash' do
      engine.plant_seed(**default_attrs)
      report = engine.garden_report
      expect(report).to include(:total_plants, :total_plots, :by_type,
                                :flourishing, :withered, :thirsty, :avg_health)
    end

    it 'handles empty garden' do
      report = engine.garden_report
      expect(report[:total_plants]).to eq(0)
      expect(report[:avg_health]).to eq(0.0)
    end
  end
end
