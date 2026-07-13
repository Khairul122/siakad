<?php

namespace App\Http\Controllers\Api;

use App\Models\Khs;
use App\Services\AkademikService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class KhsController extends BaseCrudController
{
    protected string $modelClass = Khs::class;
    protected ?string $ownerColumn = 'uid';
    protected array $fillable = ['tahun_akademik', 'semester', 'kode', 'mata_kuliah', 'sks', 'kelas', 'tugas', 'uts', 'uas'];
    protected array $writeRoles = [];
    protected bool $dosenReadsAll = true;

    public function __construct(private AkademikService $akademikService)
    {
    }

    public function ringkasan(Request $request): JsonResponse
    {
        $uid = $request->attributes->get('auth_role') === 'mahasiswa'
            ? $request->attributes->get('auth_user')->uid
            : $request->input('uid');

        if (!$uid) {
            return response()->json(['message' => 'Parameter uid wajib diisi untuk role selain mahasiswa'], 422);
        }

        return response()->json($this->akademikService->ringkasanPerSemester($uid));
    }
}
