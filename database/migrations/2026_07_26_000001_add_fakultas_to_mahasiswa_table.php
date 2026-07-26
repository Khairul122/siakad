<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
<<<<<<< HEAD
        Schema::table('mahasiswa', function (Blueprint $table) {
            $table->string('fakultas')->default('')->after('prodi');
        });
=======
        if (! Schema::hasColumn('mahasiswa', 'fakultas')) {
            Schema::table('mahasiswa', function (Blueprint $table) {
                $table->string('fakultas', 100)->default('Teknik')->after('prodi');
            });
        }
>>>>>>> aebfdd82d833f46cde946e9c4432d5c692daa421
    }

    public function down(): void
    {
<<<<<<< HEAD
        Schema::table('mahasiswa', function (Blueprint $table) {
            $table->dropColumn('fakultas');
        });
=======
        if (Schema::hasColumn('mahasiswa', 'fakultas')) {
            Schema::table('mahasiswa', function (Blueprint $table) {
                $table->dropColumn('fakultas');
            });
        }
>>>>>>> aebfdd82d833f46cde946e9c4432d5c692daa421
    }
};
