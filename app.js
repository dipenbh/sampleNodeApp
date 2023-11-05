const express = require('express');
const os = require('os');
const app = express();
const si = require('systeminformation');
const winston = require('winston');
const fs = require('fs');

// Function to generate a random number between 1 and 100
function getRandomNumber() {
  return Math.floor(Math.random() * 10000) + 1;
}

// Get PC details
const userInfo = os.userInfo();
const hostname = os.hostname();
const platform = os.platform();

// Get OS name
const osName = os.platform();
const logDir = 'app-logs';



const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: `${logDir}/app.log` })
  ]
});

async function writeApplog()
{
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir);
  }
  logger.info('This is an application log.');
}

// Get RAM and HDD size
async function getSystemInfo() {
  const data = await si.get({
    cpu: '*',
    mem: '*',
    diskLayout: '*',
  });

  return {
    osName,
    ramSize: data.mem.total,
    hddSize: data.diskLayout[0].size,
  };
}

app.get('/', async (req, res) => {
  writeApplog();
	  const systemInfo = await getSystemInfo();
  res.send(`
    <h1>Hello, World!</h1>
    <p>Random Number: ${getRandomNumber()}</p>
    <p>User: ${userInfo.username}</p>
    <p>Hostname: ${hostname}</p>
    <p>Platform: ${platform}</p>
	<p>OS: ${systemInfo.osName}</p>
    <p>RAM Size: ${systemInfo.ramSize} bytes</p>
    <p>HDD Size: ${systemInfo.hddSize} bytes</p>
  `);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});