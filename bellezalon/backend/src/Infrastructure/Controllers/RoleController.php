<?php
namespace App\Infrastructure\Controllers;

use App\Domain\Entities\Role;
use App\Domain\Repositories\RoleRepositoryInterface;
use App\Domain\Repositories\ModuleRepositoryInterface;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class RoleController {
    private RoleRepositoryInterface $roleRepository;
    private ModuleRepositoryInterface $moduleRepository;

    public function __construct(RoleRepositoryInterface $roleRepository, ModuleRepositoryInterface $moduleRepository) {
        $this->roleRepository = $roleRepository;
        $this->moduleRepository = $moduleRepository;
    }

    public function getAll(Request $request, Response $response): Response {
        try {
            $roles = $this->roleRepository->findAll();
            $data = array_map(function(Role $role) {
                return [
                    'id' => $role->getId(),
                    'name' => $role->getName(),
                    'description' => $role->getDescription(),
                    'modules' => array_map(function($m) {
                        return [
                            'id' => $m->getId(),
                            'name' => $m->getName()
                        ];
                    }, $role->getModules())
                ];
            }, $roles);

            $response->getBody()->write(json_encode($data));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response->getBody()->write(json_encode([
                'error' => 'Error getAll: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]));
            return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
        }
    }

    public function getModules(Request $request, Response $response): Response {
        try {
            $modules = $this->moduleRepository->findAll();
            $data = array_map(function($m) {
                return ['id' => $m->getId(), 'name' => $m->getName()];
            }, $modules);

            $response->getBody()->write(json_encode($data));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response->getBody()->write(json_encode([
                'error' => 'Error getModules: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]));
            return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
        }
    }

    public function create(Request $request, Response $response): Response {
        try {
            $data = $request->getParsedBody();
            $role = new Role(null, $data['name'], $data['description'] ?? '');
            $roleId = $this->roleRepository->save($role);
            
            if (isset($data['module_ids'])) {
                $this->roleRepository->updatePermissions($roleId, $data['module_ids']);
            }

            $response->getBody()->write(json_encode(['success' => true, 'id' => $roleId]));
            return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response->getBody()->write(json_encode([
                'error' => 'Error create: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]));
            return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
        }
    }

    public function update(Request $request, Response $response, array $args): Response {
        try {
            $id = (int)$args['id'];
            $data = $request->getParsedBody();
            
            $role = new Role($id, $data['name'], $data['description'] ?? '');
            $this->roleRepository->save($role);

            if (isset($data['module_ids'])) {
                $this->roleRepository->updatePermissions($id, $data['module_ids']);
            }

            $response->getBody()->write(json_encode(['success' => true]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response->getBody()->write(json_encode([
                'error' => 'Error update: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]));
            return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
        }
    }

    public function delete(Request $request, Response $response, array $args): Response {
        try {
            $id = (int)$args['id'];
            $this->roleRepository->delete($id);
            $response->getBody()->write(json_encode(['success' => true]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Throwable $e) {
            $response->getBody()->write(json_encode([
                'error' => 'Error delete: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]));
            return $response->withStatus(200)->withHeader('Content-Type', 'application/json');
        }
    }
}
