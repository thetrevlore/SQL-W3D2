require 'byebug'
require 'singleton'
require 'sqlite3'
require_relative 'Question.rb'
require_relative 'Reply.rb'
require_relative 'User.rb'
require_relative 'Question_Follow'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end








class QuestionLike


end

class QuestionFollow

end
