<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('krs_mata_kuliah', function (Blueprint $table) {
            $table->foreignId('kelas_kuliah_id')->nullable()->after('krs_id')->constrained('kelas_kuliah')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('krs_mata_kuliah', function (Blueprint $table) {
            $table->dropConstrainedForeignId('kelas_kuliah_id');
        });
    }
};
