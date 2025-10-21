create table bibliotek
(
    bibliotek_code serial primary key,
    name_bibliotek text not null,
    adress_bibliotek text not null
);

create table tema
(
    tema_code serial primary key,
    tema_name text not null
);

create table autors
(
    autor_code serial primary key,
    autor_name text not null
);

create table readers
(
    readers_code serial primary key,
    full_name text not null,
    adress_readers text,
    telenum numeric(12)
);

create table book
(
    book_code serial,
    bibliotek_code int not null,
    tema_code int not null,
    autor_code int not null,
    name_book text not null,
    made_in text,
    place_made_in text,
    year_made_in int,
    number_made_book int,
    primary key (book_code, bibliotek_code),
    foreign key (bibliotek_code) references bibliotek(bibliotek_code),
    foreign key (tema_code) references tema(tema_code),
    foreign key (autor_code) references autors(autor_code)
);

create table abonement
(
    bibliotek_code int not null,
    book_code int not null,
    readers_code int not null,
    date_give date not null,
    date_ungive date,
    avans numeric(10,2),
    primary key (bibliotek_code, book_code, readers_code, date_give),
    foreign key (bibliotek_code, book_code) references book(bibliotek_code, book_code),
    foreign key (readers_code) references readers(readers_code)
);

insert into bibliotek(name_bibliotek, adress_bibliotek)
values ('Центральная городская библиотека', 'г. Москва, ул. Ленина, 10'),
('Библиотека №2 им. Чехова', 'г. Москва, ул. Чехова, 5');

select * from bibliotek;
select * from tema;

insert into tema(tema_name)
values
	('Русская литература'),
	('Иностранная литература'),
	('Научная литература');

insert into autors (autor_name)
values
	('Фёдор Достоевский'),
	('Лев Толстой'),
	('Джордж Оруэлл');

insert into book (
    bibliotek_code, 
    tema_code, 
    autor_code, 
    name_book, 
    made_in, 
    place_made_in, 
    year_made_in, 
    number_made_book
)
select 
    bibl.bibliotek_code,
    t.tema_code,
    a.autor_code,
    v.name_book,
    v.made_in,
    v.place_made_in,
    v.year_made_in,
    v.number_made_book
from (
    values
        ('Центральная городская библиотека', 'Русская литература', 'Фёдор Достоевский', 'Преступление и наказание', 'Эксмо', 'Москва', 2020, 5),
        ('Центральная городская библиотека', 'Русская литература', 'Лев Толстой', 'Война и мир', 'АСТ', 'Москва', 2019, 3),
        ('Библиотека №2 им. Чехова', 'Иностранная литература', 'Джордж Оруэлл', '1984', 'Penguin Books', 'Лондон', 2018, 4)
) as v(name_bibliotek, tema_name, autor_name, name_book, made_in, place_made_in, year_made_in, number_made_book)
join bibliotek bibl on bibl.name_bibliotek = v.name_bibliotek
join tema t on t.tema_name = v.tema_name
join autors a on a.autor_name = v.autor_name;

-- ==== Данные читателей ====
insert into readers (full_name, adress_readers, telenum)
values
('Иванов Иван Иванович', 'г. Москва, ул. Горького, 7', 89161112233),
('Петрова Анна Сергеевна', 'г. Москва, пр-т Мира, 15', 89263334455);

-- ==== Данные абонементов ====
-- ==== Данные абонементов (через JOIN) ====
insert into abonement (bibliotek_code, book_code, readers_code, date_give, date_ungive, avans)
select 
    b.bibliotek_code,
    b.book_code,
    r.readers_code,
    a.date_give,
    a.date_ungive,
    a.avans
from (
    values
        ('Центральная городская библиотека', 'Преступление и наказание', 'Иванов Иван Иванович', '2025-10-10'::date, '2025-10-20'::date, 200.00),
        ('Центральная городская библиотека', 'Война и мир', 'Петрова Анна Сергеевна', '2025-10-11'::date, null, 150.00),
        ('Библиотека №2 им. Чехова', '1984', 'Иванов Иван Иванович', '2025-10-12'::date, '2025-10-19'::date, 100.00)
) as a(name_bibliotek, name_book, full_name, date_give, date_ungive, avans)
join bibliotek lib on lib.name_bibliotek = a.name_bibliotek
join book b on b.name_book = a.name_book and b.bibliotek_code = lib.bibliotek_code
join readers r on r.full_name = a.full_name;

select * from abonement