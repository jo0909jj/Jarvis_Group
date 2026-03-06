import YahooFinance from 'yahoo-finance2';

const yahooFinance = new YahooFinance();

async function getEnergyPrices() {
    try {
        // 原油期貨 (WTI)
        const wti = await yahooFinance.quote('CL=F');
        // 布倫特原油
        const brent = await yahooFinance.quote('BZ=F');
        // 天然氣
        const ng = await yahooFinance.quote('NG=F');

        const result = {
            timestamp: new Date().toISOString(),
            crude_oil: {
                wti: {
                    price: wti.regularMarketPrice,
                    change: wti.regularMarketChange,
                    changePercent: wti.regularMarketChangePercent
                },
                brent: {
                    price: brent.regularMarketPrice,
                    change: brent.regularMarketChange,
                    changePercent: brent.regularMarketChangePercent
                }
            },
            natural_gas: {
                henry_hub: {
                    price: ng.regularMarketPrice,
                    change: ng.regularMarketChange,
                    changePercent: ng.regularMarketChangePercent
                }
            },
            risk_level: calculateRiskLevel(
                Math.max(wti.regularMarketPrice, brent.regularMarketPrice),
                ng.regularMarketPrice
            )
        };

        console.log(JSON.stringify(result, null, 2));
        return result;
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

function calculateRiskLevel(oilPrice, gasPrice) {
    let level = 'GREEN';
    let score = 0;

    // 原油評分
    if (oilPrice > 150) score += 3;
    else if (oilPrice > 120) score += 2;
    else if (oilPrice > 100) score += 1;

    // 天然氣評分
    if (gasPrice > 12) score += 3;
    else if (gasPrice > 8) score += 2;
    else if (gasPrice > 5) score += 1;

    // 風險等級
    if (score >= 5) level = 'RED';
    else if (score >= 3) level = 'ORANGE';
    else if (score >= 1) level = 'YELLOW';

    return {
        level,
        score,
        oil_threshold: oilPrice > 100 ? (oilPrice > 120 ? (oilPrice > 150 ? 'CRITICAL' : 'HIGH') : 'MODERATE') : 'NORMAL',
        gas_threshold: gasPrice > 5 ? (gasPrice > 8 ? (gasPrice > 12 ? 'CRITICAL' : 'HIGH') : 'MODERATE') : 'NORMAL'
    };
}

getEnergyPrices();
