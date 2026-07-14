<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class UploadController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'file' => ['required', 'file', 'image', 'max:5120'],
            'folder' => ['nullable', 'string', 'alpha_dash', 'max:50'],
        ]);

        if ($validator->fails()) {
            return response()->json(['message' => 'Validasi gagal', 'errors' => $validator->errors()], 422);
        }

        $folder = $request->input('folder', 'general');
        $file = $request->file('file');
        $filename = Str::uuid()->toString().'.'.$file->getClientOriginalExtension();

        $path = $file->storeAs("uploads/{$folder}", $filename, 'public');

        return response()->json([
            'url' => url('storage/'.$path),
        ], 201);
    }
}
