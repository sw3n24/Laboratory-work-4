-- Видалення таблиць з каскадним видаленням можливих описів цілісності
DROP TABLE "user" CASCADE;
DROP TABLE noise_level CASCADE;
DROP TABLE environment CASCADE;
DROP TABLE recommendations CASCADE;
DROP TABLE health_indicators CASCADE;
DROP TABLE alert CASCADE;

-- Опис таблиці environment
CREATE TABLE environment (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор середовища
    type VARCHAR(50), -- тип середовища
    temperature NUMERIC, -- температура
    lighting VARCHAR(50) -- освітлення
);

-- Опис таблиці noise_level
CREATE TABLE noise_level (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор рівня шуму
    current_level NUMERIC, -- поточний рівень шуму
    norm_level NUMERIC, -- норма рівня шуму
    environment_id INT REFERENCES environment (id) -- зв'язок із середовищем
);

-- Опис таблиці user
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор користувача
    name VARCHAR(100), -- ім'я користувача
    location VARCHAR(100), -- локація користувача
    health_indicators_id INT REFERENCES health_indicators (id),
    -- зв'язок із таблицею health_indicators
    environment_id INT REFERENCES environment (id)
    -- зв'язок із таблицею environment
);

-- Опис таблиці health_indicators
CREATE TABLE health_indicators (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор показників здоров'я
    pulse INT, -- пульс
    temperature NUMERIC -- температура
);

-- Опис таблиці recommendations
CREATE TABLE recommendations (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор рекомендації
    text VARCHAR(255), -- текст рекомендації
    status VARCHAR(20), -- статус виконання
    alert_id INT REFERENCES alert (id) -- зв'язок із таблицею alert
);

-- Опис таблиці alert
CREATE TABLE alert (
    id SERIAL PRIMARY KEY, -- унікальний ідентифікатор попередження
    text VARCHAR(255), -- текст попередження
    type VARCHAR(50), -- тип попередження
    noise_level_id INT REFERENCES noise_level (id)
    -- зв'язок із таблицею noise_level
);

-- Обмеження цілісності для текстових полів
ALTER TABLE "user" ADD CONSTRAINT user_name_check
CHECK (name ~ '^[A-Za-z\\s]+$');

ALTER TABLE recommendations ADD CONSTRAINT rec_text_check
CHECK (text ~ '^[A-Za-z0-9\\s\\.,!?]+$');

-- Обмеження для перевірки значення температури
ALTER TABLE health_indicators ADD CONSTRAINT hi_temperature_range
CHECK (temperature BETWEEN 36 AND 42);

-- Обмеження для перевірки рівня шуму
ALTER TABLE noise_level ADD CONSTRAINT nl_current_level_range
CHECK (current_level BETWEEN 0 AND 150);

-- Обмеження для перевірки email
ALTER TABLE "user" ADD CONSTRAINT user_email_check
CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$');

-- Обмеження для перевірки мобільного телефону
ALTER TABLE "user" ADD CONSTRAINT user_mobile_check
CHECK (mobile ~ '^\\(\\d{3}\\)\\d{3}-\\d{4}$');
