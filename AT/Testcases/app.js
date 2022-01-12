import puppeteer from "puppeteer";

async function run(){
    try {
        const browser = await puppeteer.launch({
            headless: false,
            defaultViewport: null,
        });
        const url = "https://www.accuquilt.com/",
        const page = await browser.newPage();
        await page.goto(url);
        await page.waitForNavigation();
        await browser.close();
    } catch(e){
        console.error(`Error:${e}`);
    }
}

const clickSelector = async (page, selector) => {
    await page.waitForSelector(selector, {timeout});
    await page.Seval(selector, (elem) => elem.click({delay: 1000}));
};

