<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Krs;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class KrsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Krs::with('mataKuliah');

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('uid', $request->attributes->get('auth_user')->uid);
        } elseif ($request->filled('uid')) {
            $query->where('uid', $request->input('uid'));
        }

        return response()->json($query->get());
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $krs = Krs::with('mataKuliah')->find($id);

        if (!$krs || !$this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        return response()->json($krs);
    }

    public function store(Request $request): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa yang bisa membuat KRS'], 403);
        }

        $validator = Validator::make($request->all(), [
            'tahun_akademik' => ['required', 'string', 'max:20'],
            'semester' => ['required', 'string', 'max:20'],
            'mata_kuliah' => ['required', 'array', 'min:1'],
            'mata_kuliah.*.nama' => ['required', 'string'],
            'mata_kuliah.*.kode' => ['nullable', 'string'],
            'mata_kuliah.*.sks' => ['nullable', 'string'],
            'mata_kuliah.*.kelas' => ['nullable', 'string'],
            'mata_kuliah.*.hari' => ['nullable', 'string'],
            'mata_kuliah.*.pukul' => ['nullable', 'string'],
            'mata_kuliah.*.ruang' => ['nullable', 'string'],
            'mata_kuliah.*.status' => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $uid = $request->attributes->get('auth_user')->uid;

        $krs = DB::transaction(function () use ($data, $uid) {
            $krs = Krs::create([
                'uid' => $uid,
                'tahun_akademik' => $data['tahun_akademik'],
                'semester' => $data['semester'],
            ]);

            foreach ($data['mata_kuliah'] as $mk) {
                $krs->mataKuliah()->create($mk);
            }

            return $krs->load('mataKuliah');
        });

        return response()->json($krs, 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $krs = Krs::find($id);

        if (!$krs || !$this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        $validator = Validator::make($request->all(), [
            'tahun_akademik' => ['sometimes', 'string', 'max:20'],
            'semester' => ['sometimes', 'string', 'max:20'],
            'mata_kuliah' => ['sometimes', 'array'],
            'mata_kuliah.*.nama' => ['required_with:mata_kuliah', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();

        DB::transaction(function () use ($krs, $data) {
            $krs->update(collect($data)->only(['tahun_akademik', 'semester'])->toArray());

            if (array_key_exists('mata_kuliah', $data)) {
                $krs->mataKuliah()->delete();
                foreach ($data['mata_kuliah'] as $mk) {
                    $krs->mataKuliah()->create($mk);
                }
            }
        });

        return response()->json($krs->load('mataKuliah'));
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $krs = Krs::find($id);

        if (!$krs || !$this->canAccess($request, $krs)) {
            return response()->json(['message' => 'KRS tidak ditemukan'], 404);
        }

        $krs->delete();

        return response()->json(['message' => 'KRS berhasil dihapus']);
    }

    private function canAccess(Request $request, Krs $krs): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return true;
        }

        return $krs->uid === $request->attributes->get('auth_user')->uid;
    }
}
