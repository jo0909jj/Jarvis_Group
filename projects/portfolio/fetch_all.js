import YahooFinance from 'yahoo-finance2';

const yahooFinance = new YahooFinance();

async function getPortfolioPrices() {
    try {
        // 台股
        const tw006208 = await yahooFinance.quote('006208.TW');
        // 美股
        const msft = await yahooFinance.quote('MSFT');
        const googl = await yahooFinance.quote('GOOGL');
        // USD/TWD 匯率
        const usdtwd = await yahooFinance.quote('USDTWD=X');

        const result = {
            timestamp: new Date().toISOString(),
            fx_rate: {
                usd_twd: usdtwd.regularMarketPrice
            },
            holdings: {
                '006208.TW': {
                    name: '富邦台50',
                    price: tw006208.regularMarketPrice,
                    change: tw006208.regularMarketChange,
                    changePercent: tw006208.regularMarketChangePercent,
                    currency: 'TWD'
                },
                'MSFT': {
                    name: 'Microsoft',
                    price: msft.regularMarketPrice,
                    change: msft.regularMarketChange,
                    changePercent: msft.regularMarketChangePercent,
                    currency: 'USD'
                },
                'GOOGL': {
                    name: 'Alphabet Inc A',
                    price: googl.regularMarketPrice,
                    change: googl.regularMarketChange,
                    changePercent: googl.regularMarketChangePercent,
                    currency: 'USD'
                }
            }
        };

        // 計算 TWD 等值
        const fxRate = usdtwd.regularMarketPrice;
        result.holdings['MSFT'].price_twd = msft.regularMarketPrice * fxRate;
        result.holdings['GOOGL'].price_twd = googl.regularMarketPrice * fxRate;

        console.log(JSON.stringify(result, null, 2));
        return result;
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

getPortfolioPrices();
