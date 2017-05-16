require_relative 'questions_database'
require_relative 'Reply'

class User
  attr_accessor :id, :fname, :lname

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end

  def self.find_by_id(id)
    a = QuestionsDatabase.instance.execute(<<-SQL, id)
    Select *
    from
    users
    where
    id = ?
    SQL
    User.new(a.first)
  end

  def self.find_by_name(fname, lname)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
    *
    FROM
    users
    WHERE
    fname = ? AND
    lname = ?
    SQL
    User.new(user_data.first)
  end


  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
    raise "#{self} is already in the database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?,?)
      SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} is not in the database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
      users
    SET
      fname = ?, lname = ?
    WHERE
      id = ?
    SQL
  end

  def authored_questions
    Question.find_by_author(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_question_user_id(@id)
  end

end
