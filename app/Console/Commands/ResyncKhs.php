<?php

namespace App\Console\Commands;

use App\Models\Nilai;
use App\Services\AkademikService;
use Illuminate\Console\Command;

class ResyncKhs extends Command
{
    protected $signature = 'khs:resync {--dry : Do not write changes, just show counts}';
    protected $description = 'Resync KHS rows from existing Nilai records';

    public function __construct(private AkademikService $akademikService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $this->info('Scanning Nilai records to resync KHS...');

        $pairs = Nilai::select('mahasiswa_uid', 'kelas_kuliah_id')
            ->distinct()
            ->get()
            ->map(fn($r) => [$r->mahasiswa_uid, $r->kelas_kuliah_id]);

        $this->info('Found ' . $pairs->count() . ' unique mahasiswa+kelas combinations');

        $i = 0;
        foreach ($pairs as $pair) {
            [$uid, $kelasId] = $pair;
            if ($this->option('dry')) {
                $this->line("Would sync: uid={$uid} kelas={$kelasId}");
                $i++;
                continue;
            }

            $this->akademikService->syncKhs($uid, $kelasId);
            $i++;
        }

        $this->info("Processed {$i} pairs");

        return 0;
    }
}
