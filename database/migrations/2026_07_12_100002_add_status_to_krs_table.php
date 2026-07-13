<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('krs', function (Blueprint $table) {
            $table->enum('status', ['diajukan', 'disetujui', 'ditolak'])->default('diajukan')->after('semester');
            $table->text('catatan_dosen')->nullable()->after('status');
            $table->string('disetujui_oleh', 128)->nullable()->after('catatan_dosen');
            $table->timestamp('disetujui_at')->nullable()->after('disetujui_oleh');

            $table->foreign('disetujui_oleh')->references('uid')->on('dosen')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('krs', function (Blueprint $table) {
            $table->dropForeign(['disetujui_oleh']);
            $table->dropColumn(['status', 'catatan_dosen', 'disetujui_oleh', 'disetujui_at']);
        });
    }
};
