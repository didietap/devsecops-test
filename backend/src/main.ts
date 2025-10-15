import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import * as apm from 'elastic-apm-node';
import { Logger } from 'pino';
import pino from 'pino';
import { LoggerMiddleware } from './shared/logger.middleware';
import { MetricsService } from './shared/metrics.service';

const logger: Logger = pino({ level: process.env.LOG_LEVEL || 'info' });

// Initialize Elastic APM if configured
if (process.env.ELASTIC_APM_SERVER_URL) {
  apm.start({
    serviceName: process.env.ELASTIC_APM_SERVICE_NAME || 'devsecops-backend',
    serverUrl: process.env.ELASTIC_APM_SERVER_URL,
    environment: process.env.NODE_ENV || 'development',
  });
  logger.info('Elastic APM initialized');
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { logger: false });
  app.use(helmet());
  app.use(LoggerMiddleware(logger));
  app.enableShutdownHooks();

  // metrics endpoint
  const metricsService = app.get(MetricsService);
  // Mount metrics on /metrics route (express)
  const server = await app.listen(3000, '0.0.0.0');
  logger.info(`Server listening on port 3000`);

  // expose metrics via express (Nest uses Express under the hood)
  const expressApp: any = app.getHttpAdapter().getInstance();
  expressApp.get('/metrics', async (_req: any, res: any) => {
    res.set('Content-Type', metricsService.register.contentType);
    res.send(await metricsService.register.metrics());
  });
}
bootstrap().catch((err) => {
  logger.error({ err }, 'Bootstrap failed');
  process.exit(1);
});
