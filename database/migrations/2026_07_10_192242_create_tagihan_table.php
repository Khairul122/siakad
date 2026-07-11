<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tagihan', function (Blueprint $table) {
            $table->id();
            $table->string('uid', 128);
            $table->string('jenis', 100);
            $table->decimal('nominal', 15, 2)->default(0);
            $table->enum('status', ['Belum Dibayar', 'Menunggu Konfirmasi', 'Lunas'])->default('Belum Dibayar');
            $table->date('jatuh_tempo')->nullable();
            $table->string('metode_pembayaran', 50)->default('');
            $table->string('bank_tujuan', 100)->default('');
            $table->string('no_rekening', 50)->default('');
            $table->string('bukti_url', 500)->default('');
            $table->text('catatan')->nullable();
            $table->string('tanggal_konfirmasi', 50)->default('');
            $table->string('tanggal_lunas', 50)->default('');

            $table->foreign('uid')->references('uid')->on('mahasiswa')->cascadeOnDelete();
            $table->index(['uid', 'status'], 'idx_tagihan_uid_status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tagihan');
    }
};
