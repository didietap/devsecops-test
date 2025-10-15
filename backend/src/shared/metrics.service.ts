import { Injectable } from '@nestjs/common';
import client, { Registry } from 'prom-client';

@Injectable()
export class MetricsService {
  public register: Registry;

  constructor() {
    this.register = new client.Registry();
    client.collectDefaultMetrics({ register: this.register, prefix: 'devsecops_' });

    // example custom metric
    const reqCounter = new client.Counter({
      name: 'devsecops_requests_total',
      help: 'Total number of requests',
      labelNames: ['method', 'route', 'status'],
      registers: [this.register],
    });

    // expose counter via DI for future use
    // (controllers / middleware can increment)
  }
}
