<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tagihan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TagihanController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Tagihan::query();

        if ($request->attributes->get('auth_role') === 'mahasiswa') {
            $query->where('uid', $request->attributes->get('auth_user')->uid);
        } elseif ($request->filled('uid')) {
            $query->where('uid', $request->input('uid'));
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        return response()->json($query->get());
    }

    public function show(Request $request, int $id): JsonResponse
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan || !$this->canAccess($request, $tagihan)) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        return response()->json($tagihan);
    }

    public function store(Request $request): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen/staf yang bisa membuat tagihan'], 403);
        }

        $validator = Validator::make($request->all(), [
            'uid' => ['required', 'string', 'exists:mahasiswa,uid'],
            'jenis' => ['required', 'string', 'max:100'],
            'nominal' => ['required', 'numeric', 'min:0'],
            'jatuh_tempo' => ['nullable', 'date'],
            'metode_pembayaran' => ['nullable', 'string'],
            'bank_tujuan' => ['nullable', 'string'],
            'no_rekening' => ['nullable', 'string'],
            'catatan' => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $tagihan = Tagihan::create($validator->validated());

        return response()->json($tagihan, 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen/staf yang bisa mengubah tagihan'], 403);
        }

        $tagihan = Tagihan::find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        $tagihan->update($request->only([
            'jenis', 'nominal', 'status', 'jatuh_tempo', 'metode_pembayaran',
            'bank_tujuan', 'no_rekening', 'bukti_url', 'catatan',
        ]));

        return response()->json($tagihan);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen/staf yang bisa menghapus tagihan'], 403);
        }

        Tagihan::where('id', $id)->delete();

        return response()->json(['message' => 'Tagihan berhasil dihapus']);
    }

    public function konfirmasi(Request $request, int $id): JsonResponse
    {
        $tagihan = Tagihan::find($id);

        if (!$tagihan || !$this->canAccess($request, $tagihan)) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        if ($request->attributes->get('auth_role') !== 'mahasiswa') {
            return response()->json(['message' => 'Hanya mahasiswa pemilik tagihan yang bisa konfirmasi bayar'], 403);
        }

        $validator = Validator::make($request->all(), [
            'bukti_url' => ['required', 'string'],
            'catatan' => ['nullable', 'string'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $tagihan->update([
            'bukti_url' => $request->input('bukti_url'),
            'catatan' => $request->input('catatan', $tagihan->catatan),
            'status' => 'Menunggu Konfirmasi',
            'tanggal_konfirmasi' => now()->toDateTimeString(),
        ]);

        return response()->json($tagihan);
    }

    public function lunas(Request $request, int $id): JsonResponse
    {
        if ($request->attributes->get('auth_role') !== 'dosen') {
            return response()->json(['message' => 'Hanya dosen/staf yang bisa menandai lunas'], 403);
        }

        $tagihan = Tagihan::find($id);

        if (!$tagihan) {
            return response()->json(['message' => 'Tagihan tidak ditemukan'], 404);
        }

        $tagihan->update([
            'status' => 'Lunas',
            'tanggal_lunas' => now()->toDateTimeString(),
        ]);

        return response()->json($tagihan);
    }

    private function canAccess(Request $request, Tagihan $tagihan): bool
    {
        if ($request->attributes->get('auth_role') === 'dosen') {
            return true;
        }

        return $tagihan->uid === $request->attributes->get('auth_user')->uid;
    }
}
