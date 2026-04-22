<?php
namespace App\Domain\Entities;

class User {
    private ?int $id;
    private string $username;
    private string $password;
    private int $roleId;
    private ?string $roleName;
    private array $permissions;
    private string $estado;
    private ?string $fullName;
    private ?string $email;
    private ?string $phone;
    private ?string $city;
    private ?string $neighborhood;
    private ?string $address;
    private ?string $avatarUrl;
    private ?string $technicalSheet;

    public function __construct(
        ?int $id, 
        string $username, 
        string $password, 
        int $roleId,
        ?string $roleName = null,
        array $permissions = [],
        string $estado = 'activo',
        ?string $fullName = null,
        ?string $email = null,
        ?string $phone = null,
        ?string $city = null,
        ?string $neighborhood = null,
        ?string $address = null,
        ?string $avatarUrl = null,
        ?string $technicalSheet = null
    ) {
        $this->id = $id;
        $this->username = $username;
        $this->password = $password;
        $this->roleId = $roleId;
        $this->roleName = $roleName;
        $this->permissions = $permissions;
        $this->estado = $estado;
        $this->fullName = $fullName;
        $this->email = $email;
        $this->phone = $phone;
        $this->city = $city;
        $this->neighborhood = $neighborhood;
        $this->address = $address;
        $this->avatarUrl = $avatarUrl;
        $this->technicalSheet = $technicalSheet;
    }

    public function getId(): ?int { return $this->id; }
    public function getUsername(): string { return $this->username; }
    public function getPassword(): string { return $this->password; }
    public function getRoleId(): int { return $this->roleId; }
    public function getRoleName(): ?string { return $this->roleName; }
    public function getPermissions(): array { return $this->permissions; }
    public function getEstado(): string { return $this->estado; }
    public function getFullName(): ?string { return $this->fullName; }
    public function getEmail(): ?string { return $this->email; }
    public function getPhone(): ?string { return $this->phone; }
    public function getCity(): ?string { return $this->city; }
    public function getNeighborhood(): ?string { return $this->neighborhood; }
    public function getAddress(): ?string { return $this->address; }
    public function getAvatarUrl(): ?string { return $this->avatarUrl; }
    public function getTechnicalSheet(): ?string { return $this->technicalSheet; }
}
