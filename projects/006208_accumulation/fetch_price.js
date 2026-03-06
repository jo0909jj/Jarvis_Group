import YahooFinance from 'yahoo-finance2';

const yahooFinance = new YahooFinance();

async function getPrice() {
    try {
        const result = await yahooFinance.quote('006208.TW');
        console.log(JSON.stringify({
            symbol: result.symbol,
            price: result.regularMarketPrice,
            change: result.regularMarketChange,
            changePercent: result.regularMarketChangePercent,
            previousClose: result.previousClose,
            open: result.regularMarketOpen,
            dayHigh: result.regularMarketDayHigh,
            dayLow: result.regularMarketDayLow,
            volume: result.regularMarketVolume,
            timestamp: new Date().toISOString()
        }, null, 2));
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

getPrice();
