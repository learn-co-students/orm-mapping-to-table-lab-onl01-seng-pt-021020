class Student
  attr_accessor :name, :grade
  attr_reader :id
  
  # class methods
  def self.create(kwargs)
    student = self.new(kwargs[:name], kwargs[:grade])
    student.save
    student
  end
  
  def self.create_table
    sql = <<~SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<~SQL
      DROP TABLE IF EXISTS students;
    SQL
    
    DB[:conn].execute(sql)
  end
  
  
  # instance methods
  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end
  
  def save
    sql = <<~SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL
    
    DB[:conn].execute(sql, @name, @grade)
    
    @id = DB[:conn].execute('SELECT last_insert_rowid() from sqlite_master;')[0][0]
  end
  
end
