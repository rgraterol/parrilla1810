json.array!(@provincias) do |provincia|
  json.extract! provincia, :provincia_nombre, :provincia_id
end