import cron from 'node-cron';
import { autoCompleteConsultations } from './autoCompleteConsultations.js';
import { logger } from '../utils/logger.js';

/**
 * Job Scheduler
 * Manages all scheduled background jobs for the application
 */

class JobScheduler {
    constructor() {
        this.jobs = [];
    }

    /**
     * Initialize and start all scheduled jobs
     */
    startAll() {
        logger.info('🚀 Starting job scheduler...');

        // Auto-complete consultations - runs every hour
        const autoCompleteJob = cron.schedule('0 * * * *', async () => {
            await autoCompleteConsultations();
        }, {
            scheduled: true,
            timezone: 'Africa/Algiers' // Adjust to your timezone
        });

        this.jobs.push({
            name: 'Auto-Complete Consultations',
            schedule: 'Every hour (0 * * * *)',
            job: autoCompleteJob
        });

        logger.info(`✅ Scheduled ${this.jobs.length} background jobs:`);
        this.jobs.forEach(({ name, schedule }) => {
            logger.info(`   - ${name}: ${schedule}`);
        });

        // Run auto-complete job immediately on startup (then every hour)
        logger.info('⚡ Running initial auto-complete job...');
        autoCompleteConsultations().catch(err => {
            logger.error('❌ Error in initial auto-complete job:', err);
        });
    }

    /**
     * Stop all scheduled jobs (useful for graceful shutdown)
     */
    stopAll() {
        logger.info('🛑 Stopping all scheduled jobs...');
        this.jobs.forEach(({ name, job }) => {
            job.stop();
            logger.info(`   ✅ Stopped: ${name}`);
        });
    }

    /**
     * Get status of all jobs
     */
    getStatus() {
        return this.jobs.map(({ name, schedule, job }) => ({
            name,
            schedule,
            running: job.running || false
        }));
    }
}

// Export singleton instance
export const scheduler = new JobScheduler();
