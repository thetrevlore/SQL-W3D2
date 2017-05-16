require_relative 'Reply'


class Question

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map {|datum| Question.new(datum)}
  end

  def self.find_by_author(author_id)
    this_question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    this_question.map {|el| Question.new(el)}
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def self.find_by_id(id)
    q = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
        SQL

        Question.new(q.first)
  end

  def author
    this_author = QuestionsDatabase.instance.execute(<<-SQL, @author_id)
    SELECT
      fname, lname
    FROM
      users
    WHERE
      id = ?
    SQL

    "#{this_author.first['fname']} #{this_author.first['lname']}"
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

end
