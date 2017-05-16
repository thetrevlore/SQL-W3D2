class QuestionFollow

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map {|datum| QuestionFollow.new(datum)}
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_follows
    ON
      users.id = question_follows.user_id
    WHERE
      question_follows.questions_id = ?
    SQL
    followers.map {|el| User.new(el)}
  end

  def self.followed_question_user_id(user_id)
    followed = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    questions.*
    FROM
    question_follows
    JOIN
    questions
    ON
    question_follows.questions_id = questions.id
    WHERE
    question_follows.questions_id = ?
    SQL
    followed.map {|el| Question.new(el)}

  end

  def self.most_followed_questions(n)
    most_followed = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_follows
    ON
      question_follows.questions_id = questions.id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(questions.id) DESC
    LIMIT ?
    SQL

    most_followed
  end

  def initialize(option)
    @id = option['id']
    @user_id = option['user_id']
    @questions_id = option['questions_id']
  end

end
