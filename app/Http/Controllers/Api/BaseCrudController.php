<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

abstract class BaseCrudController extends Controller
{
    protected string $modelClass;
    protected ?string $ownerColumn = null;
    protected array $fillable = [];
    protected array $writeRoles = ['mahasiswa', 'dosen'];
    protected bool $scopedRead = true;
    protected bool $dosenReadsAll = false;

    protected function currentUid(Request $request): ?string
    {
        $user = $request->attributes->get('auth_user');
        return $user?->getKey();
    }

    protected function currentRole(Request $request): ?string
    {
        return $request->attributes->get('auth_role');
    }

    protected function scopedQuery(Request $request)
    {
        $query = ($this->modelClass)::query();

        $bypassOwnerFilter = $this->dosenReadsAll && $this->currentRole($request) === 'dosen';

        if ($this->ownerColumn && $this->scopedRead && !$bypassOwnerFilter) {
            $query->where($this->ownerColumn, $this->currentUid($request));
        }

        return $query;
    }

    protected function authorizeWrite(Request $request): ?JsonResponse
    {
        if (!in_array($this->currentRole($request), $this->writeRoles, true)) {
            return response()->json(['message' => 'Akses ditolak untuk role ini'], 403);
        }

        return null;
    }

    protected function findScoped(Request $request, int|string $id): ?Model
    {
        return $this->scopedQuery($request)->find($id);
    }

    public function index(Request $request): JsonResponse
    {
        return response()->json($this->scopedQuery($request)->get());
    }

    public function show(Request $request, int|string $id): JsonResponse
    {
        $item = $this->findScoped($request, $id);

        if (!$item) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        return response()->json($item);
    }

    public function store(Request $request): JsonResponse
    {
        if ($response = $this->authorizeWrite($request)) {
            return $response;
        }

        $data = $request->only($this->fillable);

        if ($this->ownerColumn) {
            $data[$this->ownerColumn] = $this->currentUid($request);
        }

        $item = ($this->modelClass)::create($data);

        return response()->json($item, 201);
    }

    public function update(Request $request, int|string $id): JsonResponse
    {
        if ($response = $this->authorizeWrite($request)) {
            return $response;
        }

        $item = $this->findScoped($request, $id);

        if (!$item) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $item->update($request->only($this->fillable));

        return response()->json($item);
    }

    public function destroy(Request $request, int|string $id): JsonResponse
    {
        if ($response = $this->authorizeWrite($request)) {
            return $response;
        }

        $item = $this->findScoped($request, $id);

        if (!$item) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $item->delete();

        return response()->json(['message' => 'Berhasil dihapus']);
    }
}
