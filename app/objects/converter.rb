# frozen_string_literal: true

class Converter
  def convert(bytes)
    unit = kind(bytes)

    if unit == 'B'
      "#{bytes} #{unit}"
    else
      "#{calculate(bytes, unit.to_sym)} #{unit}"
    end
  end

  private

  def kind(bytes)
    case bytes
    when 0..1024
      'B'
    when 1024..((1024**2) - 1)
      'KB'
    when (1024**2)..((1024**3) - 1)
      'MB'
    when (1024**3)..((1024**4) - 1)
      'GB'
    else
      'TB'
    end
  end

  def calculate(bytes, unit)
    units = { KB: 1, MB: 2, GB: 3, TB: 4 }

    size = bytes.to_f / (1024**units[unit])
    size.round(2)
  end
end
