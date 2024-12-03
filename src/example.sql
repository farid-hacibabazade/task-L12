CREATE TABLE authors
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128),
    last_name  VARCHAR(128),
    email      VARCHAR(256),
    created_at TIMESTAMP
);

CREATE TABLE posts
(
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(255),
    created_at TIMESTAMP,
    update_at  TIMESTAMP
);

ALTER TABLE authors
    ADD COLUMN about TEXT;

ALTER TABLE authors
    ADD COLUMN nick VARCHAR(128);

CREATE TABLE authors_posts
(
    id        SERIAL PRIMARY KEY,
    author_id INT REFERENCES authors (id),
    post_id   INT REFERENCES posts (id)
);

ALTER TABLE authors
    ALTER COLUMN created_at SET DEFAULT NOW();

CREATE TABLE subscribers
(
    id    SERIAL PRIMARY KEY,
    email VARCHAR(255)
);

ALTER TABLE authors
    ADD CONSTRAINT authors_nick_email_key UNIQUE (nick, email);

ALTER TABLE posts
    ADD COLUMN image_url VARCHAR(2048);

CREATE TABLE tags
(
    id         SERIAL PRIMARY KEY,
    tag        VARCHAR(255),
    created_at TIMESTAMP
);

CREATE TABLE posts_tags
(
    id      SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES posts (id),
    tag_id  INTEGER REFERENCES tags (id)
);

CREATE INDEX idx_tags_tag ON tags (tag);

ALTER TABLE authors
    ADD COLUMN github    VARCHAR(2048),
    ADD COLUMN update_at TIMESTAMP;

CREATE OR REPLACE VIEW authors_posts_view AS
SELECT a.nick       AS author_nick,
       p.title      AS post_title,
       p.created_at AS post_created_at
FROM authors_posts ap
         INNER JOIN posts p on ap.post_id = p.id
         INNER JOIN authors a on ap.author_id = a.id;

ALTER TABLE subscribers
    ALTER COLUMN email SET NOT NULL;

ALTER TABLE subscribers
    ADD COLUMN author_id INT REFERENCES authors (id);


-- ONE-TO-ONE

INSERT INTO authors
VALUES (DEFAULT, 'Ali', 'Valiyev', 'valiyev55@mail.ru', '2024-09-03 17:39:37.000000',
        'I am full stack developer.', 'ali_v', 'github.com/ali-v', null);

INSERT INTO authors
VALUES (DEFAULT, 'Rustem', 'Hesenov', 'rustem.h@gmail.com', '2024-10-03 17:42:32.000000',
        'I have 5 years experience', 'hesenov-rst', 'github.com/heseovrustem', null);

INSERT INTO authors
VALUES (DEFAULT, 'Amal', 'Eliyev', 'amal88@mail.ru', '2024-05-03 17:44:01.000000',
        'I am back-end developer', 'amal.lyv', 'github.com/amal-lyv', null);

INSERT INTO subscribers (id, email, author_id)
VALUES (DEFAULT, 'emil.memmedli@gmail.com', 2),
       (DEFAULT, 'ayla_cumayeva@gmai.com', 1),
       (DEFAULT, 'gunay.umarova@mail.ru', 3);

SELECT a.first_name,
       a.email,
       a.github,
       s.email AS subscriber_email
FROM authors a
         INNER JOIN subscribers s ON a.id = s.author_id;

--ONE-TO-MANY

ALTER TABLE posts
    ADD COLUMN author_id INT REFERENCES authors (id);

INSERT INTO posts (id, title, created_at, update_at, image_url, author_id)
VALUES (DEFAULT, 'Html', '2024-11-03 18:00:02.000000', '2024-12-03 18:00:13.000000',
        'https://www.investopedia.com/terms/h/html.asp152ad', 2);

INSERT INTO posts (id, title, created_at, update_at, image_url, author_id)
VALUES (DEFAULT, 'Generics', '2024-08-03 18:01:53.000000', '2024-12-01 18:02:01.000000',
        'https://journaldev.nyc3.cdn.digitaloceanspaces.com/2013/07/generics-in-java.png', 3);

INSERT INTO posts (id, title, created_at, update_at, image_url, author_id)
VALUES (DEFAULT, 'Data structure', '2024-08-22 18:03:02.000000', null,
        'https://medium.com/swlh/data-structures-the-basics-dc356cb97111', 3);

INSERT INTO posts (id, title, created_at, update_at, image_url, author_id)
VALUES (DEFAULT, 'JavaScript', '2023-06-09 18:04:58.000000', null,
        'https://lh3.googleusercontent.com/uB7Hli_4TgMeaS6cF', 2);

SELECT a.first_name,
       a.last_name,
       a.github,
       p.title AS post_title,
       p.created_at AS post_created_at,
       p.image_url
FROM authors a
         INNER JOIN posts p on a.id = p.author_id;