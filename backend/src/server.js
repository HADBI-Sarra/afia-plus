import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const envPath = path.resolve(__dirname, '../.env');

dotenv.config({ path: envPath });

console.log('ENV PATH:', envPath);
console.log('SUPABASE_URL:', process.env.SUPABASE_URL);

import('./app.js').then(module => {
  const app = module.default;
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`📍 Listening on all interfaces (0.0.0.0:${PORT})`);
  });
}).catch(err => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
