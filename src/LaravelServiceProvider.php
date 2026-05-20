<?php

declare(strict_types=1);

namespace Upmind\ProvisionProviders\GenericApi;

use Upmind\ProvisionBase\Laravel\ProvisionServiceProvider;
use Upmind\ProvisionProviders\GenericApi\Providers\RPC\Provider as RpcProvider;

class LaravelServiceProvider extends ProvisionServiceProvider
{
    /**
     * @return void
     */
    public function boot()
    {
        $this->bindCategory('generic-api', Category::class);

        // $this->bindProvider('generic', 'example', ExampleProvider::class);

        $this->bindProvider('generic-api', 'rpc', RpcProvider::class);
    }
}
