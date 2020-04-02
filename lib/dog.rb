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
  else
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
    def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
  end
  
  
  
end