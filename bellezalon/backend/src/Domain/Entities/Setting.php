<?php
namespace App\Domain\Entities;

class Setting {
    private string $keyName;
    private string $value;
    private string $category;

    public function __construct(string $keyName, string $value, string $category) {
        $this->keyName = $keyName;
        $this->value = $value;
        $this->category = $category;
    }

    public function getKeyName(): string { return $this->keyName; }
    public function getValue(): string { return $this->value; }
    public function getCategory(): string { return $this->category; }
}
