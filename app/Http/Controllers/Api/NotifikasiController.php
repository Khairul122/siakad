<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notifikasi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NotifikasiController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->attributes->get('auth_user');
        $role = $request->attributes->get('auth_role');
        $tipeUser = $role === 'mahasiswa' ? 'Mahasiswa' : 'Dosen';

        $notifikasi = Notifikasi::where('uid', $user->getKey())
            ->where('tipe_user', $tipeUser)
            ->orderByDesc('created_at')
            ->get();

        return response()->json($notifikasi);
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'uid' => ['required', 'string', 'max:128'],
            'tipe_user' => ['required', 'in:Mahasiswa,Dosen'],
            'judul' => ['required', 'string', 'max:255'],
            'isi' => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $data = $validator->validated();
        $data['created_at'] = now();

        $notifikasi = Notifikasi::create($data);

        return response()->json($notifikasi, 201);
    }

    public function markAsRead(Request $request, int $id): JsonResponse
    {
        $notifikasi = $this->findOwned($request, $id);

        if (!$notifikasi) {
            return response()->json(['message' => 'Notifikasi tidak ditemukan'], 404);
        }

        $notifikasi->update(['dibaca' => true]);

        return response()->json($notifikasi);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $notifikasi = $this->findOwned($request, $id);

        if (!$notifikasi) {
            return response()->json(['message' => 'Notifikasi tidak ditemukan'], 404);
        }

        $notifikasi->delete();

        return response()->json(['message' => 'Notifikasi berhasil dihapus']);
    }

    private function findOwned(Request $request, int $id): ?Notifikasi
    {
        $user = $request->attributes->get('auth_user');
        $role = $request->attributes->get('auth_role');
        $tipeUser = $role === 'mahasiswa' ? 'Mahasiswa' : 'Dosen';

        return Notifikasi::where('id', $id)
            ->where('uid', $user->getKey())
            ->where('tipe_user', $tipeUser)
            ->first();
    }
}
