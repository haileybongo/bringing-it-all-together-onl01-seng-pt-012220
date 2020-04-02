class Dog 
  
  attr_accessor :name, :breed
  attr_reader :id 
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
      SQL

    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
      self
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL
  
      DB[:conn].execute(sql, self.name, self.breed)
  
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
    end
  end
  
  def self.new_from_db(array)
    id = array[0]
    name = array[1]
    breed = array[2]
    new_dog = self.new(id: id, name: name, breed: breed) 
    new_dog  
  end
  
    def self.find_by_name(name)
      sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
    def self.create(name:, breed:)
    new_dog = self.new(name: name, breed: breed)
    new_dog.save
  end
  
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def self.find_by_id(id)
    sql = <<-SQL
    SELECT *
    FROM dogs
    WHERE id = ?
    LIMIT 1
    SQL
 
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.find_or_create_by(name:, album:)
      song = DB[:conn].execute("SELECT * FROM songs WHERE name = ? AND album = ?", name, album)
      if !song.empty?
        song_data = song[0]
        song = Song.new(song_data[0], song_data[1], song_data[2])
      else
        song = self.create(name: name, album: album)
    end
    song
  end
  
end