import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get('health')
  health() {
    return { status: 'ok' };
  }

  @Get('ready')
  ready() {
    // implement readiness checks for DB, caches in future
    return { status: 'ready' };
  }
}
