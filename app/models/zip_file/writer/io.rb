class ZipFile::Writer::IO
  def initialize(writer)
    @writer = writer
  end

  def write(data)
    @writer.write(data)
  end

  def <<(data)
    write(data)
    self
  end

  def size
    @writer.byte_size
  end
end
