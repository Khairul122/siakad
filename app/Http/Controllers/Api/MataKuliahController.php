<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MataKuliah;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MataKuliahController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = MataKuliah::query();

        if ($request->filled('prodi')) {
            $query->where('prodi', $request->input('prodi'));
        }

        if ($request->filled('semester_ke')) {
            $query->where('semester_ke', $request->input('semester_ke'));
        }

        return response()->json($query->get());
    }

    public function show(int $id): JsonResponse
    {
        $mataKuliah = MataKuliah::find($id);

        if (!$mataKuliah) {
            return response()->json(['message' => 'Mata kuliah tidak ditemukan'], 404);
        }

        return response()->json($mataKuliah);
    }
}
