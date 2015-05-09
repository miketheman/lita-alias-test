require 'spec_helper'

describe Lita::Handlers::Alias,
         lita_handler: true,
         additional_lita_handlers: Lita::Handlers::Help do
  let(:robot) { Lita::Robot.new(registry) }
  subject { described_class.new(robot) }

  describe 'routes' do
    it 'receives commands and routes them' do
      expect(described_class).to route_command('alias FOO BAR').to :alias
      expect(described_class).to route_command('unalias FOO BAR').to :unalias
    end

    it 'does not take action when not spoken to directly' do
      expect(described_class).not_to route('alias FOO BAR')
    end

    it 'does not route another plugin command' do
      expect(described_class).to_not route_command('sandwich')
    end
  end

  describe '#alias' do
    context 'new' do
      it 'sets and responds' do
        send_command('alias FOO BAR')
        expect(replies.last).to eq "Alias 'FOO' has been set to: BAR"
      end
    end

    context 'existing alias' do
      it 'overrides stored alias' do
        send_command('alias bar BAZ')
        expect(replies.last).to eq "Alias 'bar' has been set to: BAZ"
        send_command('alias bar quux')
        expect(replies.last).to eq "Alias 'bar' has been set to: quux"

        send_message('bar')
        expect(replies.last).to eq 'quux'
      end

      it 'does not duplicate responses' do
        pending('responds with count of times alias overridden')
        send_command('alias baz quux')
        send_command('alias baz norf')
        send_message('baz')

        expect(replies.count('norf')).to eq 1
      end
    end
  end

  describe '#unalias' do
    context 'alias exists' do
      it 'removes stored alias' do
        send_command('alias BAZ luhrman')
        send_command('unalias BAZ')
        expect(replies.last).to eq "Alias 'BAZ' has been removed."
      end
    end

    context 'does not exist' do
      it 'responds with an error message' do
        send_command('unalias BAZ')
        expect(replies.last).to eq "Alias 'BAZ' does not exist."
      end
    end
  end

  describe '#load_stored_aliases' do
    before do
      subject.redis.set 'simple', 'command'
    end

    it 'from redis and registers them' do
      pending 'Does not register in test suite, need a trigger?'
      send_command('help alias')
      expect(replies.last).to end_with 'simple - alias to: command'
    end
  end

  describe 'dynamic alias' do
    pending
    it 'listens for a set alias and responds' do
      send_command('alias heart breaker')

      send_message('heart')
      expect(replies.last).to eq 'breaker'
    end
  end
end
