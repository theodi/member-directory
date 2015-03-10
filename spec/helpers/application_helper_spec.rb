require 'spec_helper'

describe ApplicationHelper do
  describe 'indefinite article helper' do
    {
      'test' => 'a test',
      'badger' => 'a badger',
      'apple' => 'an apple',
      'egg' => 'an egg',
      'Idiot' => 'an Idiot',
      'Otter' => 'an Otter',
      'utterance' => 'an utterance',
      'missle' => 'a missle'
    }.each do |word, fragment|
      it 'adds a to words starting with consonants' do
        expect(helper.indefinite_article(word)).to eq(fragment)
      end
    end
  end
end
