<?php

namespace App\Infrastructure\Persistence;

use App\Domain\Model\Subject;
use PDO;

class MysqlSubjectRepository {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findAll(): array {
        $stmt = $this->db->query("SELECT * FROM subjects");
        return $stmt->fetchAll();
    }

    public function findUnitsBySubjectId(string $subjectId): array {
        $stmt = $this->db->prepare("SELECT * FROM units WHERE subject_id = ? ORDER BY order_index ASC");
        $stmt->execute([$subjectId]);
        return $stmt->fetchAll();
    }
}
