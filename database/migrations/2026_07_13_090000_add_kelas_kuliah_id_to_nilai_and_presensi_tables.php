<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('nilai', function (Blueprint $table) {
            $table->foreignId('kelas_kuliah_id')->nullable()->after('kelas')->constrained('kelas_kuliah')->nullOnDelete();
        });

        Schema::table('presensi', function (Blueprint $table) {
            $table->foreignId('kelas_kuliah_id')->nullable()->after('kelas')->constrained('kelas_kuliah')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('nilai', function (Blueprint $table) {
            $table->dropConstrainedForeignId('kelas_kuliah_id');
        });

        Schema::table('presensi', function (Blueprint $table) {
            $table->dropConstrainedForeignId('kelas_kuliah_id');
        });
    }
};
