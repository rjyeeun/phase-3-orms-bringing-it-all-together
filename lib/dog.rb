class Dog
    attr_accessor :name, :breed, :id
def initialize(name:, breed:, id:nil)
    @id = id
    @name = name
    @breed = breed
end

def self.create_table
    sql = "CREATE TABLE dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
    )"
    DB[:conn].execute(sql)
end

def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
end

def save
    sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
    # insert the dog
    DB[:conn].execute(sql, self.name, self.breed)

    # get the dog ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    # return the Ruby instance
    self
    end

    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.all
    sql = "SELECT * FROM dogs"

    DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
    end
    end

    def self.find_by_name(name)
        sql = 
         "SELECT *
         FROM dogs
         WHERE name=?
         LIMIT 1"
    
        DB[:conn].execute(sql, name).map do |row|
          self.new_from_db(row)
        end.first
      end

    def self.find(id)
        sql =
         "SELECT *
         FROM dogs
         WHERE id = ?
         LIMIT 1"
        objects= DB[:conn].execute(sql,id).map {
        |row| self.new_from_db(row)}
        objects.first
    end
end
