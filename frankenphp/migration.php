<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

final class Version20230401CreateEmployeeTable extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Creates the Employee table in the database.';
    }

    public function up(Schema $schema): void
    {
        $this->addSql('CREATE TABLE symfony_demo_employee (id INT NOT NULL, name VARCHAR(255) NOT NULL, PRIMARY KEY(id))');
    }

    public function down(Schema $schema): void
    {
        $this->addSql('DROP TABLE symfony_demo_employee');
    }
}
