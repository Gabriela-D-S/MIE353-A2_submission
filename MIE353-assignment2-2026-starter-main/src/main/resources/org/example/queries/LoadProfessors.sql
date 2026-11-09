CREATE TABLE IF NOT EXISTS professor (
    profId     INT PRIMARY KEY,
    lastName   VARCHAR(100) NOT NULL,
    firstName  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    office     VARCHAR(50)
);
COPY professor FROM 'src/main/resources/data/professors.csv';