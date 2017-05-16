DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255),
  lname VARCHAR(255)

);

INSERT INTO
  users (fname, lname)
VALUES
  ('Trevor', 'Storey'),
  ('Wadah', 'Adlan');

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body TEXT,
  author_id INTEGER,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('HOW?!?', 'How do I do this?', (SELECT id FROM users WHERE fname = 'Trevor')),
  ('WHY?!?', 'Why do I do this', (SELECT id FROM users WHERE fname = 'Wadah'));

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  question_follows (questions_id, user_id)
VALUES
  (
    (SELECT id FROM questions WHERE title = 'HOW?!?'),
    (SELECT id FROM users WHERE id = 1)
  ),
  (
    (SELECT id FROM questions WHERE title = 'WHY?!?'),
    (SELECT id FROM users WHERE id = 2)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  parent_id INT,
  user_id INT,
  body TEXT,

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 1, "HELLO WORLD"),
  (1,1,2,"HELLO TREVOR");

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INT,
  user_id INT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1,2),
  (2,1);

















--
