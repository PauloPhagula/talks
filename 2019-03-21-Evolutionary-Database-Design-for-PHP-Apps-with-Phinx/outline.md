# PHP migrations with Phinx

## ME me me 

## Why do we need migrations?

> Migrations are about evolutionary database design that rely on applying continuous integration and automated refactoring to database development, together with a close collaboration between DBAs and application developers. The techniques work in both pre-production and released systems, in green field projects as well as legacy systems. ... We began around 2000 with a project whose database ended up with around 600 tables. As we worked on this project we developed techniques that allowed to change the schema and migrate existing data comfortably. This allowed our database to be completely flexible and evolvable.
>
> -- Pramod Sadalage & Martin Fowler, Evolutionary Database Design

## Common Features of Migrations

- Database Versioning - Migration frameworks typically keep a version table in a migrated database indicating the migration version applied to it. Making it easy to tell if your current codebase is compatible.
- Schema Versioning - Migrations are typically committed to source control beside the code that depends on them. This makes it quite easy to branch and isolate your work or go back in time in the code and be able to run any version of your application.
- Downgrading - Migration frameworks typically offer a method of downgrading to an earlier version of the schema. This makes it easy to push changes to a database at design time and remove them if the feature is rolled back.
- Persistence Ignorance - Migration frameworks frequently support multiple
  relational database vendors. A single set of migrations can be applied to SQL
  Server, Postgres and Sqlite. Mature frameworks even support dialects like SQL
  Server 2014 vs 2016. This allows the framework to make good choices about syntax and features.
- Repeatability - Migrations can be applied over and over again creating the exact same database. So they can be run in development, test, UAT and production with the exact same result.
- Consistency - Some migration frameworks generate migrations based on
  conventions from your model code. These conventions are applied consistently
  across the entire database. For example, a tables primary key will always be
  'Id'. But if you wish, these conventions are overridable and applied
  universally. For example, you want your primary key to always be `EntityNameId` or
  your tables to always start with `TBL_Entityname`.
- Idempotence - Migration frameworks will typically do "the right thing" when applying migrations. If a migration has been run once, it will not be run again.

## Why use Phinx?

- Super easy to install and setup 
- Write migrations in Pure PHP or SQL 
- Well documented 
- Easy to integrate with your Deploy Tool
- It’s Free and Open Source

## What is Phinx? 

- Phinx is a standalone command-line tool for managing database Migrations

## How

- Install `composer install phinx`
- Setup `phinx init`
- Checking status with `phinx status -e env` 
- Adding migrations `phinx create migrationName`
- Migrating `phinx migrate -e env` 
- Rolling back `phinx migrate -e env`

### The Example - Rotten Tomatoes clone

```yml
Rating:	R (for violence, language throughout, and some sexual content/nudity) 
Genre:Drama 
Directed By:	Steve McQueen (III) 
Written By: Steve McQueen (III), Gillian Flynn 
In Theaters:	Nov 16, 2018  
Wide On Disc/Streaming:	Feb 5, 2019 
Runtime:128 minutes 
Studio:	20th Century Fox
Cast: 
  - Viola Davis as Veronica 
  - Michelle Rodriguez as Linda
```

## Migrating 

```sh
mkdir example # create folder for project
cd example # cd into project folder
mkdir public src tests # make folders for code
composer init # initialize composer

# install phinx with composer
composer require --dev robmorgan/phinx 

# initialize phinx
vendor/bin/phinx init

# Configure it and create folders for migrations and seeds
mkdir -p src/db/migrations
mkdir -p src/db/seeds
````

The config file

```yml 
paths: 
    migrations: '%%PHINX_CONFIG_DIR%%/src/db/migrations' 
    seeds: '%%PHINX_CONFIG_DIR%%/src/db/seeds'

environments:
    default_migration_table: phinxlog
    default_database: development

    development:
        adapter: mysql
        host: localhost
        name: tomatoes
        user: root
        pass: ''
        port: 3306
        charset: utf8mb4

    testing:
        adapter: mysql
        host: localhost
        name: tomatoes_test
        user: root
        pass: ''
        port: 3306
        charset: utf8mb4

version_order: creation
```

`phinx create CreateMovieTable`

```php 
// create the table
$movies = $this->table('movies');
$movies
    ->addColumn('name', 'string')
    ->addColumn('year', 'integer', ['signed' => true])
    ->addIndex(['name', 'year'], ['unique' => true])
    ->create();
```

```sh
# Do dry run
phinx migrate -e development --dry-run
# Migrate
phinx migrate -e development 
# Check status
phinx status -e development
# Rollback
phinx rollback -e development
# Check status
phinx status -e development
```


## Seeding

`phinx seed:create MovieSeeder`

```php
<?php

use Phinx\Seed\AbstractSeed;

class MovieSeeder extends AbstractSeed
{
    public function run()
    {
        $movies = $this->table('movies');

        // empty the table
        $movies->truncate();

        // NOTE: Could be as much records as we want or
        $data = [
            'name' => 'Black Panther',
            'year' => 2018
        ];

        $movies
            ->insert($data)
            ->save();
    }
}
```

`phinx seed:run -S MovieSeeder`

```php
<?php


use Phinx\Migration\AbstractMigration;

class AddRatingsTable extends AbstractMigration
{
    public function change()
    {
        $this
          ->table('ratings', ['id' => false, 'primary_key' => [ 'code']])
          ->addColumn('code', 'string', ['limit' => 10, 'null' => false])
          ->addColumn('description', 'string', ['limit' => 255, 'null' => false])
          ->create();
    }
}

<?php


use Phinx\Migration\AbstractMigration;

class AddMovieMetadata extends AbstractMigration
{
    public function change()
    {
        $this
          ->table('movies')
          ->addColumn('rating', 'string', ['limit' => 10, 'null' => true])
          ->addColumn('in_theathers', 'date')
          ->addColumn('on_disc', 'date')
          ->addForeignKey('rating', 'ratings', 'code', ['delete'=> 'CASCADE', 'update'=> 'NO_ACTION'])
          ->save();
    }
}
```

```sql
CREATE DATABASE movies;

use movies;

CREATE TABLE movies (
  id int unsigned NOT NULL AUTO_INCREMENT,
  name varchar(255),
  year int,
  PRIMARY KEY (id),
  UNIQUE KEY (name, year)
);

CREATE TABLE people (
  id int unsigned NOT NULL AUTO_INCREMENT,
  name varchar(255),
  bio text,
  birthday date,
  PRIMARY KEY (id)
);

CREATE TABLE movie_roles (
  id int unsigned NOT NULL AUTO_INCREMENT, 
  person_id int unsigned,
  movie_id int unsigned,
  role varchar(255),
  PRIMARY KEY (id),
  CONSTRAINT fk_movie_roles_person_id FOREIGN KEY (person_id) REFERENCES people(id),
  CONSTRAINT fk_movie_roles_movie_id FOREIGN KEY (movie_id) REFERENCES movies(id)
);
```
