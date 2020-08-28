<?php


use Phinx\Seed\AbstractSeed;

class MovieSeeder extends AbstractSeed
{
    /**
     * Run Method.
     *
     * Write your database seeder using this method.
     *
     * More information on writing seeders is available here:
     * http://docs.phinx.org/en/latest/seeding.html
     */
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
