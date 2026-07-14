<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Dosen;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DosenController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(Dosen::all());
    }

    public function show(string $uid): JsonResponse
    {
        $dosen = Dosen::find($uid);

        if (! $dosen) {
            return response()->json(['message' => 'Dosen tidak ditemukan'], 404);
        }

        return response()->json($dosen);
    }

    public function update(Request $request, string $uid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen' || $request->attributes->get('auth_user')->uid !== $uid) {
            return response()->json(['message' => 'Hanya pemilik akun yang bisa mengubah profil ini'], 403);
        }

        $dosen = Dosen::find($uid);

        if (! $dosen) {
            return response()->json(['message' => 'Dosen tidak ditemukan'], 404);
        }

        $dosen->update($request->only(['nama', 'nip', 'photo_url', 'prodi', 'fcm_token']));

        return response()->json($dosen);
    }

    public function destroy(Request $request, string $uid): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen' || $request->attributes->get('auth_user')->uid !== $uid) {
            return response()->json(['message' => 'Hanya pemilik akun yang bisa menghapus akun ini'], 403);
        }

        Dosen::where('uid', $uid)->delete();

        return response()->json(['message' => 'Akun berhasil dihapus']);
    }
}
