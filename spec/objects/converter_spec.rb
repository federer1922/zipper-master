# frozen_string_literal: true

require 'rails_helper'

describe Converter do
  it 'adds unit for bytes' do
    size = Converter.new.convert(800)

    expect(size).to eq '800 B'
  end

  it 'converts bytes to kilobytes' do
    size = Converter.new.convert(46_878)

    expect(size).to eq '45.78 KB'
  end

  it 'converts bytes to megabytes' do
    size = Converter.new.convert(2_621_440)

    expect(size).to eq '2.5 MB'
  end

  it 'converts bytes to gigabytes' do
    size = Converter.new.convert(14_227_000_000)

    expect(size).to eq '13.25 GB'
  end

  it 'converts bytes to terabytes' do
    size = Converter.new.convert(1_242_448_000_000)

    expect(size).to eq '1.13 TB'
  end
end
