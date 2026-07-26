<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (! Schema::hasColumn('mahasiswa', 'fakultas')) {
            Schema::table('mahasiswa', function (Blueprint $table) {
                $table->string('fakultas', 100)->default('Teknik')->after('prodi');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('mahasiswa', 'fakultas')) {
            Schema::table('mahasiswa', function (Blueprint $table) {
                $table->dropColumn('fakultas');
            });
        }
    }
};
