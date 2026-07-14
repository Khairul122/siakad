<?php

namespace App\Filament\Resources\Notifikasis\Pages;

use App\Filament\Resources\Notifikasis\NotifikasiResource;
use App\Models\Dosen;
use App\Models\Mahasiswa;
use App\Models\Notifikasi;
use Filament\Resources\Pages\CreateRecord;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Validation\ValidationException;

class CreateNotifikasi extends CreateRecord
{
    protected static string $resource = NotifikasiResource::class;

    public function getMaxContentWidth(): string
    {
        return 'full';
    }

    /**
     * Satu submit form langsung menyebar notifikasi ke SEMUA mahasiswa atau
     * SEMUA dosen (tergantung tipe_user yang dipilih), tanpa perlu memilih
     * penerima satu per satu. Tetap tersimpan sebagai baris terpisah per
     * penerima sesuai kolom `uid` di tabel.
     */
    protected function handleRecordCreation(array $data): Model
    {
        $tipeUser = $data['tipe_user'];
        $modelClass = $tipeUser === 'Dosen' ? Dosen::class : Mahasiswa::class;
        $uids = $modelClass::query()->pluck('uid')->all();

        if (empty($uids)) {
            throw ValidationException::withMessages([
                'data.tipe_user' => 'Belum ada data '.($tipeUser === 'Dosen' ? 'dosen' : 'mahasiswa').' untuk dikirimi notifikasi.',
            ]);
        }

        $record = null;

        foreach ($uids as $uid) {
            $record = Notifikasi::create([
                'uid' => $uid,
                'tipe_user' => $tipeUser,
                'judul' => $data['judul'],
                'isi' => $data['isi'] ?? null,
                'dibaca' => $data['dibaca'] ?? false,
                'created_at' => now(),
            ]);
        }

        return $record;
    }
}
