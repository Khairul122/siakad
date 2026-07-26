<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use App\Console\Commands\ResyncKhs;

class Kernel extends ConsoleKernel
{
    protected $commands = [
        ResyncKhs::class,
    ];

    protected function schedule(Schedule $schedule): void
    {
        // $schedule->command('khs:resync')->daily();
    }

    protected function commands(): void
    {
        //
    }
}
