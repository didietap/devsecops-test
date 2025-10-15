import { Request, Response, NextFunction } from 'express';
import { Logger } from 'pino';
import { v4 as uuidv4 } from 'uuid';

export const LoggerMiddleware = (logger: Logger) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const id = req.headers['x-request-id'] || uuidv4();
    // attach request id to response header
    res.setHeader('x-request-id', id as string);

    const start = Date.now();
    logger.info({ req: { method: req.method, url: req.url, id } }, 'request:start');

    res.on('finish', () => {
      const ms = Date.now() - start;
      logger.info({ res: { statusCode: res.statusCode, duration: ms, id } }, 'request:end');
    });

    next();
  };
};
