-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE IF EXISTS User CASCADE;
DROP TABLE IF EXISTS NoiseLevel CASCADE;
DROP TABLE IF EXISTS Environment CASCADE;
DROP TABLE IF EXISTS Recommendations CASCADE;
DROP TABLE IF EXISTS HealthIndicators CASCADE;
DROP TABLE IF EXISTS Alert CASCADE;

-- Опис таблиці Environment
CREATE TABLE Environment( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор середовища
    type VARCHAR(50), -- Тип середовища
    temperature NUMERIC, -- Температура
    lighting VARCHAR(50) -- Освітлення
);

-- Опис таблиці NoiseLevel
CREATE TABLE NoiseLevel( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор рівня шуму
    current_level NUMERIC, -- Поточний рівень шуму
    norm_level NUMERIC, -- Норма рівня шуму
    environment_id INT REFERENCES Environment(id) -- Зв’язок із середовищем
);

-- Опис таблиці User
CREATE TABLE User( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    name VARCHAR(100), -- Ім'я користувача
    location VARCHAR(100), -- Локація користувача
    health_indicators_id INT REFERENCES HealthIndicators(id), -- Зв’язок із таблицею HealthIndicators
    environment_id INT REFERENCES Environment(id) -- Зв’язок із таблицею Environment
);

-- Опис таблиці HealthIndicators
CREATE TABLE HealthIndicators( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор показників здоров’я
    pulse INT, -- Пульс
    temperature NUMERIC -- Температура
);

-- Опис таблиці Recommendations
CREATE TABLE Recommendations( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор рекомендації
    text VARCHAR(255), -- Текст рекомендації
    status VARCHAR(20), -- Статус виконання
    alert_id INT REFERENCES Alert(id) -- Зв’язок із таблицею Alert
);

-- Опис таблиці Alert
CREATE TABLE Alert( 
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор попередження
    text VARCHAR(255), -- Текст попередження
    type VARCHAR(50), -- Тип попередження
    noise_level_id INT REFERENCES NoiseLevel(id) -- Зв’язок із таблицею NoiseLevel
);

-- Обмеження цілісності для текстових полів
ALTER TABLE User ADD CONSTRAINT user_name_check 
    CHECK (name ~ '^[A-Za-z\\s]+$');

ALTER TABLE Recommendations ADD CONSTRAINT rec_text_check 
    CHECK (text ~ '^[A-Za-z0-9\\s\\.,!?]+$');

-- Обмеження для перевірки значення температури
ALTER TABLE HealthIndicators ADD CONSTRAINT hi_temperature_range 
    CHECK (temperature BETWEEN 36 AND 42);

-- Обмеження для перевірки рівня шуму
ALTER TABLE NoiseLevel ADD CONSTRAINT nl_current_level_range 
    CHECK (current_level BETWEEN 0 AND 150);

-- Обмеження для перевірки email
ALTER TABLE User ADD CONSTRAINT user_email_check 
    CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');

-- Обмеження для перевірки мобільного телефону
ALTER TABLE User ADD CONSTRAINT user_mobile_check 
    CHECK (mobile ~ '^\\(\\d{3}\\)\\d{3}-\\d{4}$');
