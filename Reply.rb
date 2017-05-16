require_relative 'questions_database'

class Reply

  def self.find_by_user_id(user_id)
    this_reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    Reply.new(this_reply.first)
  end

  def self.all
      QuestionsDatabase.instance.execute('SELECT * FROM replies')
  end

  def self.find_by_question_id(question_id)
    this_reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    this_reply.map {|el| Reply.new(el) }
  end


  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']

  end

  def create
    raise "#{self} is already in the database" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body)
      INSERT INTO
        replies (question_id, parent_id,user_id, body)
      VALUES
        (?,?,?,?)
      SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    this_author = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
    SELECT
      fname, lname
    FROM
      users
    WHERE
      id = ?
     SQL
     "#{this_author.first['fname']} #{this_author.first['lname']}"
  end

  def question
    this_question = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
     SQL
     Question.new(this_question.first)
  end

  def parent_reply
    p_reply = QuestionsDatabase.instance.execute(<<-SQL, @parent_id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
     SQL
     Reply.new(p_reply.first)
  end
  
  def child_replies
    c_replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
     SQL
     c_replies.map {|el| Reply.new(el)}
  end

end
