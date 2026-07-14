<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;

class JwtMultiGuard
{
    public function handle(Request $request, Closure $next): Response
    {
        try {
            JWTAuth::parseToken();
        } catch (JWTException $e) {
            return response()->json(['message' => 'Token tidak valid atau tidak ditemukan'], 401);
        }

        foreach (['mahasiswa', 'dosen'] as $guard) {
            $user = auth($guard)->user();
            if ($user) {
                auth()->shouldUse($guard);
                $request->attributes->set('auth_role', $guard);
                $request->attributes->set('auth_user', $user);

                return $next($request);
            }
        }

        return response()->json(['message' => 'Unauthorized'], 401);
    }
}
