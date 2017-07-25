require 'pry'
class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row)
    x = Student.new
    x.id = row[0]
    x.name = row[1]
    x.grade = row[2]
    @@all << x
    x
    # create a new Student object given a row from the database
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = (?)
    SQL
    x = DB[:conn].execute(sql, 9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < 12
    SQL
    x = DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    x = DB[:conn].execute(sql, num)
  end

  def self.all_students_in_grade_x(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    x = DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10
    SQL
    x = DB[:conn].get_first_row(sql)
    Student.new_from_db(x)
  end

  def self.all
    sql = <<-SQL
    SELECT * from students
    SQL

    x = DB[:conn].execute(sql)
    x.each do |row|
      Student.new_from_db(row)
    end
    # binding.pry
    @@all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = (?)
    SQL
    x = DB[:conn].get_first_row(sql, name)
    Student.new_from_db(x)
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
    @@all = []
  end
end
