import { Module } from '@nestjs/common';
import { HealthController } from './health/health.controller';
import { MetricsService } from './shared/metrics.service';

@Module({
  imports: [],
  controllers: [HealthController],
  providers: [MetricsService],
})
export class AppModule {}
