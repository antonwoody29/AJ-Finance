import UserNotifications
import Foundation

// MARK: - Identifier Constants

private enum AJID {
    // Daily recurring
    static let morning      = "aj_morning"
    static let morningMon   = "aj_morning_mon"
    static let morningFri   = "aj_morning_fri"
    static let streak       = "aj_streak_protect"
    static let midday       = "aj_midday"
    static let afternoon    = "aj_afternoon"
    static let evening      = "aj_evening"
    static let tip          = "aj_tip"
    // Weekly recurring
    static let weekly       = "aj_weekly"
    static let lateFri      = "aj_late_friday"
    static let lateSat      = "aj_late_saturday"
    static let weekend      = "aj_weekend"
    static let lunchTue     = "aj_lunch_tue"
    static let lunchWed     = "aj_lunch_wed"
    static let lunchThu     = "aj_lunch_thu"
    static let sundayPrep   = "aj_sunday_prep"
    // New day-specific
    static let monEarly     = "aj_mon_early"
    static let monRecap     = "aj_mon_recap"
    static let tueMorning   = "aj_tue_morning"
    static let wedMorning   = "aj_wed_morning"
    static let thuEarly     = "aj_thu_early"
    static let friMorning   = "aj_fri_morning"
    static let friAfternoon = "aj_fri_afternoon"
    static let satMorning   = "aj_sat_morning"
    static let sunEvening   = "aj_sun_evening"
    static let sunPrep2     = "aj_sun_prep2"
    // Monthly recurring
    static let payday1      = "aj_payday_1st"
    static let payday15     = "aj_payday_15th"
    static let monthly2nd   = "aj_monthly_2nd"
    static let monthly5th   = "aj_monthly_5th"
    static let monthly16th  = "aj_monthly_16th"
    static let monthly20th  = "aj_monthly_20th"
    static let monthly25th  = "aj_monthly_25th"
    static let monthly28th  = "aj_monthly_28th"
    static let monthly31st  = "aj_monthly_31st"
    static let monthly1stNoon = "aj_monthly_1st_noon"
    // Fitness (daily — 3 per day)
    static let fit7am   = "aj_fit_7am"
    static let fit12pm  = "aj_fit_12pm"
    static let fit530pm = "aj_fit_530pm"
    // Fitness special (weekly)
    static let fitSat   = "aj_fit_sat"
    static let fitSun   = "aj_fit_sun"
    static let fitMon   = "aj_fit_mon"
    // Event-triggered
    static let health   = "aj_health_alert"
    static let miss48   = "aj_miss_48h"
    static let miss72   = "aj_miss_72h"
    static let miss7d   = "aj_miss_7d"
    // Missions & combo
    static let missionsEvening = "aj_missions_evening"
    static let comboReminder   = "aj_combo_reminder"
    static let comboEarned     = "aj_combo_earned"
}

// MARK: - Message Pools

private enum AJCopy {

    // MARK: Daily

    static let morning: [String] = [
        "Rise and grind, money superstar ⭐",
        "New day, new bag 💼 AJ is rooting for you!",
        "Good morning bestie 🌅 Let's make future you proud today.",
        "AJ checked in first. Your turn. 👀",
        "The grind don't stop and neither do we 🔥",
        "Every receipt logged is a vote for future you 💪",
        "Morning! Your goals didn't take a day off either 🎯",
        "Woke up and chose financial stability 💅",
        "Sun's up, bag's up. Let's lock in today 🌅",
        "Today is a gift. So is compound interest. Open both 🎁",
        "Another day to make future you proud. No pressure tho 💙",
        "Good morning! The budget is ready when you are 💼",
        "Rise, grind, and keep those finances tight 💪",
        "A new morning means a new chance to level up 🌟",
        "AJ says good morning and please don't spend recklessly today 😌",
        "Morning motivation: you are one logged receipt closer to your goals 🧾",
        "Today's energy: financially responsible and thriving ✨",
        "The bag don't wait for nobody bestie. Let's move 💸",
        "Wakey wakey eggs and savey 🍳 (savings, that is)",
        "New morning new opportunity to absolutely secure the bag 🔐",
    ]

    static let midday: [String] = [
        "Quick midday check — budget still intact? 👀",
        "Lunch break bestie! Also your goals miss you 🎯",
        "Halfway through the day. The savings goal is rooting for you 💙",
        "AJ midday drop 📲 You doing okay out there?",
        "Checking in from your pocket ☀️ How's the spending looking?",
        "Noon o'clock. Time to remember what we're saving for 💰",
        "Your financial future called. It says keep going 🔥",
        "Mid-day reminder: future you is counting on present you 💙",
        "You're doing great. Your budget is doing great. We're all doing great 💙",
        "Midday motivational thought: you are capable of absolutely securing this bag 💼",
        "Lunchtime = receipt logging time? AJ thinks yes 🧾",
        "Half the day crushed. Let's keep the second half financially tight 🎯",
        "Checking on you and your spending habits 👀 All good bestie?",
        "Midday reminder that your goals are still waiting on you 🌟",
        "Halfway point. The goals are watching. The savings are growing 💰",
        "Lunch break energy: log what you spent this morning, keep crushing it 📝",
    ]

    static let afternoon: [String] = [
        "Almost at the end of the day bestie 🌅 Strong finish?",
        "3pm slump? Your savings goal never slumps 💪",
        "Afternoon check-in! The bag won't secure itself 💼",
        "AJ checking in. You've been out here winning, right? 👀",
        "The day's not over. Log anything today? 📝",
        "Your future self is sending afternoon encouragement 🌟",
        "Keep that energy up! Goals don't take afternoon breaks 🎯",
        "You're closer to your goal than you were this morning 💙",
        "4pm check-in: did the budget survive the day so far? 👀",
        "The end of the workday approaches. AJ is cheering for you 🎉",
        "Afternoon pick-me-up: you're closer to your goal than yesterday 💪",
        "Last stretch of the day! Keep those finances locked 🔒",
        "Clocking out soon? Don't forget to log today's spending 📝",
        "The sunset is almost here. So is your savings milestone 🌅",
        "Final hours of the day. Finish strong bestie 🏁",
        "Afternoon energy check: still on budget? AJ hopes yes 💙",
        "Power through the rest of the day with that financial discipline 💎",
    ]

    static let evening: [String] = [
        "Evening check-in 📊 Did you log today's spending?",
        "The day is wrapping up. Your budget still loves you 💙",
        "Dinner time reminder: log what you spent today 📝",
        "End-of-day AJ drop 🌙 One log keeps the streak alive!",
        "Evening vibes + financial wellness = the dream 💙",
        "Before you get cozy — quick receipt log? 🧾",
        "The day had spending. The app has a log button. Do the math 😂",
        "AJ evening reminder: small steps daily = big wins monthly 🌟",
        "Evening energy! Log today before you sleep 🌙",
        "The day is wrapping up beautifully. Your log is waiting 📊",
        "Tonight's a great night to review your spending 💙",
        "Before Netflix — one quick log and you're golden 🌟",
        "End your day right: one log and the streak survives 🔥",
        "Recap the day: what did you spend? AJ wants to know 📝",
        "Evening routine: dinner ✅ log receipts ✅ feel good about finances ✅",
        "You made it through the day bestie! Now let's capture those receipts 🧾",
        "Night vibes are immaculate. So is logging your spending 😌",
    ]

    static let streakProtect: [String] = [
        "Hey… don't let your streak die tonight 🔥 Log one thing!",
        "10 PM check — your streak is still alive. Don't blow it 🌙",
        "Real quick: log something before midnight. Streak on the line ⚡",
        "AJ is literally holding your streak together rn 😅 Help me out!",
        "The streak doesn't care it's late. Neither does future you 🌃",
        "Your daily reward is waiting 🎁 Log one transaction to claim it!",
        "Midnight in 2 hours. Streak survives if you log NOW 🏃 Let's go!",
        "One tap. One transaction. That's all the streak needs 🔥",
        "Your pet noticed you haven't logged today 🐾 They're judging. Lovingly.",
        "Tonight's the night you keep the streak alive. Don't sleep on it 💪",
        "Hey! Log ONE thing tonight and the streak lives on 🔥",
        "Quick! Before midnight! One transaction keeps the chain alive 🔗",
        "Your streak is precious. One tap protects it tonight 💙",
        "It's not too late. Thirty seconds. One log. Streak saved. GO. 🏃",
        "Your future self is begging you to log something tonight 🙏",
        "The streak is literally right there. Don't let it die at this hour 😤",
    ]

    static let savingsTip: [String] = [
        "Saving $10/day = $3,650 a year. Just saying. 🤑",
        "Did you know? Automating savings makes you 3x more likely to hit goals 🎯",
        "Money tip: name your savings goals. Named goals get funded faster 💰",
        "Quick tip: unsubscribe from one thing you don't use. Free money! 💡",
        "The 24-hour rule: wait a day before any purchase over $50 🕐",
        "Tip: track every dollar for 7 days and see where it actually goes 👀",
        "Tip: your biggest wins come from fixing your biggest leaks 💧",
        "Emergency fund = financial confidence. Build yours one dollar at a time 💪",
        "Tip: future you is literally sending a thank-you note rn 📝",
        "Tip: spending less than you earn isn't sacrifice. It's power 💪",
        "The latte factor is real. $5/day = $1,825/year. Worth tracking 📊",
        "Tip: pay yourself first. Automate savings before anything else 💰",
        "You don't need more income to build wealth. You need fewer leaks 💧",
        "Tip: one no-spend day per week = hundreds saved per month 🙌",
        "The difference between rich and broke is usually habits, not income 💡",
        "Tip: every impulse purchase is a future goal being delayed 📅",
        "Building an emergency fund is the most loving thing you can do for yourself 💙",
        "Tip: round up your spending and move the difference to savings 💰",
        "Small consistent savings beat big sporadic ones every single time 📈",
        "Tip: the best budget is the one you'll actually stick to. Keep it simple 🎯",
        "A $1,000 emergency fund changes your relationship with money forever 🛡️",
        "Tip: check your subscriptions monthly. You're probably paying for things you forgot 📱",
        "The #1 wealth-building secret? Don't try to keep up with anyone else 💡",
    ]

    // MARK: Money Facts (large rotating pool)

    static let moneyFacts: [String] = [
        // History
        "The word 'salary' comes from Latin 'salarium' — Roman soldiers were sometimes paid in salt 🧂",
        "Credit cards were invented in 1950 by Diners Club — originally just for restaurants 🍽️",
        "The first ATM was installed in London in 1967. The PIN was originally 6 digits but cut to 4 🏧",
        "The US penny costs about 3 cents to produce — we literally lose money making pennies 😂",
        "Ancient Egyptians used grain and cattle as currency 4,000 years before coins existed 🌾",
        "The word 'bank' comes from 'banco' (Italian for bench) — where medieval money changers worked 🪑",
        "Gold has been used as money for over 6,000 years — the original store of value 🪙",
        "The average $1 bill lasts about 6.6 years before it's too worn to use 💵",
        "There are more $100 bills in circulation than $1 bills in the US 💯",
        "The S&P 500 has never had a negative 20-year return in its entire history 📈",
        "The first paper money was created in China around 600 AD 🇨🇳",
        "In ancient Rome, being 'worth your salt' meant being valuable enough to earn your pay 🧂",
        "The 1933 Double Eagle gold coin sold at auction for $18.9 million — most expensive ever 🪙",
        "Monopoly has printed more fake money than the US Federal Reserve prints in a given year 🎲",
        "The US has never defaulted on its debt in its 250-year history 📊",
        "Switzerland has the most ATMs per capita of any country in the world 🏧",
        "Medieval goldsmiths invented banking — they stored people's gold and issued receipts used as money 🏦",
        "The Rothschild family's 19th-century fortune would be worth roughly $350 billion in today's dollars 💰",
        "The first stock exchange opened in Amsterdam in 1602 for the Dutch East India Company 📊",
        "Paper money was so distrusted in early America that states banned it — then used it anyway 📜",
        // Psychology of money
        "People spend 12–18% more when paying by card vs cash — the 'pain of paying' effect is real 💳",
        "Seeing larger bills makes you less likely to spend — psychologists call it the denomination effect 💵",
        "Lottery winners are often no happier 1 year after winning than they were before 🎰",
        "Having a name for your savings goal makes you 42% more likely to achieve it 🏷️",
        "People work harder to avoid a $10 loss than to earn a $10 gain — that's loss aversion 🧠",
        "Decision fatigue makes you more likely to make impulse purchases later in the day ⏰",
        "The 'anchoring effect' makes a $50 item seem like a deal after you see a $200 item 🏷️",
        "Couples who talk about money weekly are significantly happier with their finances 💑",
        "Writing down your financial goals makes you 42% more likely to hit them ✍️",
        "Just thinking about your savings account can reduce the urge to spend 🧘",
        "Sleep-deprived people consistently make riskier financial decisions 💤",
        "Social media increases financial FOMO — people spend up to 20% more after scrolling 📱",
        "The average return window for impulse purchases is 3 days — waiting 72 hours saves money 🛒",
        "Budgeting apps increase savings by an average of $600–$1,000 in their first year 📱",
        "Telling a friend about your financial goal increases your chance of hitting it by 65% 💬",
        "The 'fresh start effect' means Mondays and Jan 1st are the best days to reset financial habits 📅",
        "Shopping malls are designed with no clocks and winding paths to keep you spending longer 🏬",
        "Casinos pump oxygen into the air and remove windows to keep you gambling longer 🎰",
        "The human brain processes financial losses the same way it processes physical pain 🧠",
        "Visual savings trackers (like progress bars) make you 33% more likely to reach your goal 📊",
        // Compound interest & investing
        "Warren Buffett made 99% of his net worth after his 50th birthday — compound interest is wild ⏳",
        "$100/month at 7% interest for 30 years grows to over $120,000 💰",
        "The Rule of 72: divide 72 by your annual return to see how many years to double your money 🔢",
        "Starting to invest at 25 vs 35 can result in 2–3x more money at retirement ⏳",
        "Albert Einstein allegedly called compound interest the 'eighth wonder of the world' 🌍",
        "Investing $500/month from age 25 at 8% grows to ~$1.7 million by 65 📊",
        "A 1% fee difference in investments can cost you $100,000+ over 30 years 📉",
        "Index funds beat ~90% of actively managed funds over any 15-year period 📈",
        "The S&P 500 has averaged roughly 10% annual returns historically 📊",
        "Time in the market always beats timing the market — consistency is the real edge 🎯",
        "A dollar invested at age 20 is worth roughly $21 at age 65 at 7% growth 📈",
        "$1 saved at age 30 is worth about $7 at age 65 at 7% interest 💰",
        "The best time to invest was 20 years ago. The second best time is right now 📆",
        "Dollar-cost averaging (investing the same amount monthly) removes the stress of market timing 📅",
        "401(k) matching is a 50–100% instant return — always get the full employer match first 🏆",
        "Roth IRA contributions grow tax-free and can be withdrawn tax-free in retirement 💎",
        "HSA accounts offer a triple tax benefit — the most advantaged account type available 🏥",
        "REITs let you invest in real estate without buying property or being a landlord 🏢",
        "Rebalancing your portfolio once a year keeps your risk level aligned with your goals 🎯",
        "Bonds reduce portfolio volatility — especially useful as you get closer to retirement 📊",
        // Spending stats
        "The average American spends $1,200/year on coffee — $100/month just on drinks ☕",
        "Subscriptions you forget about cost the average person $348/year 📱",
        "The average car payment in the US is over $700/month — one of the biggest budget killers 🚗",
        "Americans spend $111 billion on fast food annually 🍔",
        "The average American household carries $6,000–$10,000 in credit card debt 💳",
        "Paying only the minimum on a $5,000 credit card can take 18+ years to pay off 😬",
        "The average US wedding costs over $30,000 — same as a car or year of college 💍",
        "Americans spend about $5,400/year dining out 🍽️",
        "The average American spends $1,200/year on lottery tickets — one of the worst ROIs possible 🎟️",
        "Impulse purchases account for roughly 40% of all consumer spending 🛒",
        "The average household owns 300,000 things — most of it unused 🏠",
        "Americans throw away 40% of food they buy — roughly $1,500/year per household 🍎",
        "The average person owns 80 clothing items but wears only 20% of them regularly 👕",
        "US households spend an average of $5,000/year on entertainment 🎭",
        "The average person spends 3 hours/day on their phone — much of that time triggered by ads 📱",
        // Saving stats
        "56% of Americans can't cover a $1,000 emergency from savings 😬",
        "The average American saves only 5–7% of their income 📊",
        "People who automate savings save 73% more on average than those who transfer manually 🤖",
        "Having even a $1,000 emergency fund dramatically reduces financial stress 🛡️",
        "High-yield savings accounts earn 10x or more interest than traditional savings 💰",
        "Only 34% of Americans have a budget — but those who do feel 20% more confident about money 📋",
        "People who track their spending save an average of $1,800 more per year 📊",
        "Saving just $5 a day for 10 years at 5% interest adds up to over $23,000 💵",
        "68% of financial advisors say the #1 mistake is not having an emergency fund 🆘",
        "Meal planning saves the average household $1,500/year on groceries and takeout 🍳",
        "Setting up automatic transfers increases your odds of hitting savings goals by 3x 🔄",
        "People who keep savings in a separate account (not checking) spend less overall 🏦",
        "The 52-week saving challenge (save $1 in week 1, $2 in week 2…) adds up to $1,378 in a year 📅",
        "Zero-based budgeting (every dollar gets a job) is one of the most effective systems 📋",
        "The average person who starts an emergency fund feels financially safer within 3 months 🛡️",
        // Wealth & millionaires
        "80% of millionaires are first-generation rich — they built it themselves, didn't inherit it 💪",
        "The average millionaire has 7 streams of income 📊",
        "Most millionaires drive Toyotas or Fords — not luxury cars 🚗",
        "74% of millionaires live on a detailed budget every month 📋",
        "The average age when Americans hit their first million is 49 📅",
        "Living below your means is the single most common trait among self-made millionaires 📉",
        "88% of millionaires are college grads but many say it wasn't the key — habits were 🎓",
        "Most millionaires built wealth through real estate or small business, not just stocks 🏡",
        "Millionaires read an average of 2 books per month on finance or personal development 📚",
        "The median net worth of a US millionaire is $2.5 million — not billions 💰",
        // Credit & debt
        "A 30-day late payment can drop your credit score by 90–110 points overnight 😬",
        "Your credit score affects mortgage rates, insurance premiums, and even job applications 📋",
        "The highest possible FICO score is 850 — only about 1.7% of Americans have it 🏆",
        "Average credit card interest rate in the US is around 21% — among the most expensive debt 💳",
        "Checking your own credit score does NOT hurt it — that's a soft pull, not a hard inquiry 🔍",
        "You can get a free credit report from each bureau once a year at annualcreditreport.com 📋",
        "Debt snowball: pay off smallest debts first for motivation. Avalanche: highest rate first for math 🏔️",
        "The best credit card strategy: use it for everything, pay in full every month, earn rewards 💯",
        "Carrying a balance does NOT help your credit score — that's a myth banks love 🚫",
        "Credit utilization above 30% starts to hurt your score even if you pay on time 📉",
        // Taxes
        "The US tax code is over 70,000 pages long — and growing every year 📚",
        "You can deduct student loan interest without itemizing — most people miss this one 🎓",
        "The standard deduction is $14,600 for single filers in 2024 — most people should take it 📋",
        "Traditional IRA contributions can reduce your taxable income dollar for dollar 💰",
        "Capital gains are taxed at lower rates than ordinary income if you hold investments 1+ year 📊",
        "529 plans grow tax-free and can now be rolled into a Roth IRA if unused for school 🎓",
        "Tax-loss harvesting lets you offset gains with losses — legal way to reduce your bill 📉",
        "Freelancers can deduct home office expenses, equipment, internet, and software 💻",
        "HSA contributions, growth, and withdrawals are all tax-free if used for medical expenses 🏥",
        "The IRS offers payment plans — you can set one up online in minutes if you owe taxes 💳",
        // Housing
        "Homeowners have a median net worth 40x higher than renters in the US 🏡",
        "The 28% rule: keep housing costs under 28% of your gross monthly income 🏠",
        "A 15-year mortgage saves hundreds of thousands in interest compared to a 30-year mortgage 📊",
        "The average US home has roughly tripled in value since 1990 🏡",
        "Location matters more than the house itself — you can renovate a home, not a neighborhood 📍",
        "HOA fees can add $3,000–$10,000/year — always factor them into home-buying math 🏘️",
        "A 20% down payment avoids PMI (private mortgage insurance), saving you ~$100+/month 💰",
        "Buying the worst house on a good street is often a better investment than the reverse 🏠",
        "Renting isn't 'throwing money away' — you're buying flexibility and skipping maintenance costs 🔑",
        "Every $100/month extra applied to your mortgage principal can save years off your loan ⏩",
        // Income & career
        "Negotiating your salary just once can be worth over $1 million over a full career 💼",
        "Remote work saves the average employee $6,000–$12,000/year on commuting and expenses 🏠",
        "Learning one in-demand skill (coding, copywriting, design) can double your income 💻",
        "The average side hustle generates $1,122/month according to a 2023 survey 💰",
        "Freelancers in tech often earn 20–40% more than salaried peers for similar work 💻",
        "Selling unused stuff at home can generate $500–$2,000 for the average household 🛍️",
        "Dividend-paying stocks generate income forever — without ever selling a share 📊",
        "Real estate rentals return a median 8–12% annually including appreciation 🏡",
        "The average person works 90,000 hours in their lifetime — know what each hour is worth 💼",
        "Starting a business on the side creates legitimate tax deductions that lower your tax bill 💡",
        // FIRE & financial independence
        "The FIRE movement targets 25x your annual expenses invested — then you can retire 🔥",
        "The 4% rule: withdraw 4% of your portfolio annually in retirement and it lasts 30+ years 📊",
        "You need 25x your annual spending to be financially independent — not a specific dollar amount 🧮",
        "Financial independence is about the gap between income and spending — not just income 💡",
        "A raise means nothing if your spending rises with it — lifestyle inflation is the silent killer 📈",
        "Every $100/month in reduced spending is worth $30,000 more at retirement (at 4% rule) 📊",
        "Semi-retirement (part-time work you love) is often more realistic and sustainable than full FIRE 🏖️",
        "Geographic arbitrage — living in a low-cost area — can accelerate FIRE by 5–10 years 🌍",
        "Coast FIRE means you've saved enough that compound interest will do the rest — stop saving, enjoy 🏄",
        "Barista FIRE: semi-retire early and work just enough to cover health insurance and fun money ☕",
        // Global money facts
        "Apple has more cash on hand than the GDP of most countries 🍎",
        "Norway saves all oil revenue in a sovereign wealth fund now worth over $1.7 trillion 🇳🇴",
        "The global shadow economy (unreported transactions) is estimated at $13 trillion annually 💰",
        "Coca-Cola was originally sold as a 'brain tonic' for 5 cents a glass in 1886 🥤",
        "McDonald's is technically one of the world's largest real estate companies by assets 🏠",
        "Vatican City has the highest income per capita in Europe 🌍",
        "The global remittance market (immigrants sending money home) exceeds $700 billion/year 💸",
        "Japan's GDP is roughly the same size as it was in 1995 — 30 years of near-zero growth 🇯🇵",
        "In Japan, it's considered rude to tip at restaurants — it implies the server needs charity 🇯🇵",
        "Sweden is nearly cashless — over 98% of transactions there are digital 🇸🇪",
        // Short punchy
        "Inflation erodes 2–3% of your savings annually if it's sitting in a no-interest account 📉",
        "A 1% expense ratio in a mutual fund costs $100,000+ over 30 years compared to 0.03% index ETFs 💸",
        "Emergency fund = 3–6 months of living expenses in a liquid, accessible account 🛡️",
        "People who review their finances weekly make measurably better financial decisions 📊",
        "Financial wellness is 80% behavior and 20% knowledge — you already know enough to start 🧠",
        "The richest people are paid while they sleep — passive income is the goal 💤",
        "Net worth = assets minus liabilities. Build assets. Reduce liabilities. Simple math 📊",
        "You don't need to earn more to build wealth — you need to keep more of what you earn 💰",
        "Buying used cars and cooking at home builds wealth faster than most income raises 🏆",
        "Every dollar you don't spend is a dollar that can compound for decades 📈",
        "The fastest path to wealth is boring: earn, save, invest, wait. Repeat. 📊",
        "Financial stress is one of the top causes of relationship problems — money talks matter 💑",
        "Automating your finances is like putting your wealth-building on autopilot 🤖",
        "The average person has 26 unused gift cards with a total value of $116 — use them! 🎁",
        "Your biggest financial asset is your earning potential — invest in skills and health 💪",
        "Tracking your net worth monthly (not just spending) gives you the full financial picture 📊",
        "Every 1% rate increase on a $300,000 mortgage adds ~$180/month — rates matter enormously 🏠",
        "The median US household income is ~$74,000 — net worth is what actually counts long-term 💰",
        "People with written financial plans are 2.5x more likely to be on track for retirement ✍️",
        "Starting an emergency fund with just $500 changes how you relate to money forever 🛡️",
    ]

    // MARK: Day-specific

    static let monday: [String] = [
        "Monday means securing the bag 💼 Let's gooo",
        "New week, new energy. Your goals are calling 📣",
        "Monday dropped and you're already winning for checking in 🔥",
        "Mondays hit different when you have a savings plan 💪",
        "New week who dis? Financially responsible bestie, that's who 💅",
        "Monday is just Friday in disguise. Budget either way 💯",
        "The grind resumed. AJ resumed. Let's go 🔥",
        "This week's goal: save more than last week. Simple. 💰",
    ]

    static let monEarly: [String] = [
        "Coffee or not — you're getting this money today. AJ is hyped for you ☕",
        "Monday morning energy! The bag waits for no one ☕",
        "Early bird gets the bag. You're already winning 🌅",
    ]

    static let monRecap: [String] = [
        "How was the first day of the week spending-wise? AJ is all ears 👂",
        "Monday recap time. Did we secure or splurge? Be honest 👀",
        "Day 1 done. How's the wallet looking? AJ wants to know 💙",
    ]

    static let tuesday: [String] = [
        "Tuesday doesn't get enough credit. Secure the bag anyway 💪",
        "It's giving Tuesday energy. AJ is here for it 💙",
        "Two days in, still winning. Keep that streak alive 🔥",
        "Terrific Tuesday! Your savings goal thinks so anyway 🌟",
        "AJ Tuesday report: still rooting for you 💙",
    ]

    static let tueMorning: [String] = [
        "It's Taco Tuesday. Budget for the tacos. Don't be sad later 🌮",
        "Taco Tuesday is a lifestyle but so is saving. Do both. 🌮",
        "Tuesday tacos approved. Just log them in the app 🌮💙",
    ]

    static let wednesday: [String] = [
        "Midweek check-in! We're halfway to the weekend bag 💰",
        "Hump day is actually budget review day. AJ said so. 📝",
        "You've made it to Wednesday. The savings goal is proud 💙",
        "Wednesday: the underrated financial reset day 📊",
    ]

    static let wedMorning: [String] = [
        "We're 3 days in. Where's your budget standing? AJ needs the tea ☕",
        "Wednesday morning! Midweek check — are we on track? 📊",
        "Halfway through the week. Budget still alive? AJ hopes so 💙",
    ]

    static let thursday: [String] = [
        "Thursday = pre-weekend budget audit. How are we looking? 📊",
        "Almost Friday! Don't blow the budget at the finish line 😅",
        "One day before Friday spending temptation. Stay strong 💪",
        "Thursday is lowkey the most underrated save day 💰",
        "Pre-weekend vibes. Future you says spend wisely 👀",
    ]

    static let thuEarly: [String] = [
        "One more day then freedom. Don't blow the bag at happy hour rn 🍹",
        "Thursday morning. Almost there. Keep the budget clean 💼",
        "Pre-Friday check. Budget looking good? Stay the course 💪",
    ]

    static let friday: [String] = [
        "Happy Friday bestie 🎉 Have fun — just don't fight for your life at Target 🎯",
        "Friday energy activated ✨ Your budget says hi too.",
        "It's Friday and future you is already proud 💫",
        "Weekend unlocked. Budget still running in the background 👀",
        "TGIF and also TGIBS — Thank God I Budget Somehow 😂",
    ]

    static let friMorning: [String] = [
        "Is today payday? Because AJ is already thinking about what we're saving 👀",
        "Friday morning! If it's payday, future you gets the first cut 💰",
        "Payday Friday energy? Allocate before you celebrate 🎉",
    ]

    static let friAfternoon: [String] = [
        "Last few hours of work. Don't let Friday vibes turn into overdraft fees 😭",
        "Friday afternoon check. Weekend is close. Budget is closer. 💙",
        "Almost clock out time. Log anything? Quick before the weekend 📝",
    ]

    static let lateNight: [String] = [
        "Put the card down and nobody gets hurt 💳",
        "Late night shopping energy detected... but are you sure? 👀",
        "Sleep on it bestie. Future you will thank you 🌙",
        "It's late. The cart can wait. Promise 🛒",
        "Midnight you and morning you have very different opinions 😂",
    ]

    static let satMorning: [String] = [
        "Most people sleep in. You're checking your goals. That's different energy 💪",
        "Saturday morning! Early birds get the savings 🌅",
        "Weekend warrior mode activated. Goals don't take Saturdays off 🔥",
    ]

    static let weekend: [String] = [
        "Weekend vibes ✨ Quick AJ check-in?",
        "Saturday goals: rest, recharge, and peek at your savings 💆",
        "Enjoying your weekend? AJ is holding down the budget 🐾",
        "Weekend mode: activated. Financial wellness: still running 💅",
    ]

    static let sundayPrep: [String] = [
        "New week incoming! 5 minutes of money reflection = 5 days of clarity 💙",
        "Sunday reset: check your goals, check your vibe, check your budget 📊",
        "Tomorrow's a new week. Let's make it count 🌟",
        "Sunday is the secret weapon day. Prep your finances. Win the week 💪",
        "AJ Sunday memo: review, reset, reload 💰",
        "Rest day for the body, strategy day for the bag 💼",
    ]

    static let sunEvening: [String] = [
        "Tomorrow is Monday. Let's set the budget intentions tonight. Game time 📊",
        "Sunday evening prep. What's the financial goal this week? 🎯",
        "New week tomorrow. AJ is ready when you are. Budget meeting? 💙",
    ]

    static let sunPrep2: [String] = [
        "New week loading… What's the financial goal? Tell AJ everything 📝",
        "Sunday night final prep. Goals set? Budget planned? Let's go 🚀",
        "Tomorrow we win. Tonight we plan. Sunday night budget check 💙",
    ]

    static let payday: [String] = [
        "Not me smelling direct deposit 💵 PAYDAY!",
        "PAYDAY! Remember — future you gets a cut first 💰",
        "It's giving paycheck energy ✨ Let's allocate wisely bestie.",
        "Deposit landed. AJ is HYPED. Budget meeting in the app 📊",
        "Your bag just got bigger. Now let's make it stay that way 💼",
    ]

    // MARK: Monthly

    static let postPayday: [String] = [
        "You got paid yesterday. What happened to the plan? AJ is watching 👀",
        "Post-payday check. Did future you get their cut? 💰",
        "Yesterday was payday. Today is accountability day. AJ is here 📊",
    ]

    static let billCheck: [String] = [
        "Hey bestie. Bills coming up. You got the money? AJ hopes so 🙏",
        "Bill check reminder. Make sure the essentials are covered first 💸",
        "Bills incoming. AJ is not panicking. But AJ is checking 👀",
    ]

    static let midMonth: [String] = [
        "Halfway through. How's the budget holding up? Don't lie to AJ 😤",
        "Mid-month check. Spending on track? AJ needs the tea ☕",
        "15 days down, 15 to go. Budget review time. How we looking? 📋",
    ]

    static let monthStretch: [String] = [
        "10 more days til month end. Stretch those dollars like AJ stretches patience 😤",
        "Almost month end bestie. Make these last dollars count 💸",
        "10 days left. Stay strong. The budget is almost through 💪",
    ]

    static let endOfMonthPrep: [String] = [
        "5 days left in the month. We saving or spending? Choose wisely 💡",
        "Last stretch! 5 days to close the month strong 🎯",
        "Almost there. 5 days. Don't let the finish line fool you 💙",
    ]

    static let almostThere: [String] = [
        "Almost end of month. You came this far. Don't blow it now please 🙏",
        "3 days left in the month. So close. Stay locked in 🔒",
        "Nearly there bestie. Month end is right around the corner 💙",
    ]

    static let monthClose: [String] = [
        "Month is almost over. How'd we do? AJ needs the final numbers 📊",
        "Last day of the month. Log everything. Close it out strong 🏁",
        "Month closing. Final tally time. AJ is proud of you either way 💙",
    ]

    static let newMonth: [String] = [
        "New month new bag. Let's set those goals. AJ is ready when you are 🚀",
        "Fresh month, fresh start. What are we saving for this month? 💰",
        "New month energy! Reset. Reload. Let's go bestie 🎯",
    ]

    // MARK: Fitness

    static let fit7am   = "Time to get that ass up and get this MONEY. Let's GO 💸"
    static let fit12pm  = "Lunch break = walk break. Yes I said what I said. 🚶‍♂️"
    static let fit530pm = "That body ain't gonna build itself. AJ is begging you. 🙏"
    static let fitSat   = "Saturday is not a rest day. It's a GRIND day. Let's go champ 🏆"
    static let fitSun   = "Sunday reset hits harder when you actually worked out. Trust AJ. 💪"
    static let fitMon   = "New week, new body goals. You promised AJ. Don't let us down. 👀"

    // MARK: Event-triggered

    static let miss48: [String] = [
        "I saved your spot 🐾 Come back whenever you're ready.",
        "AJ has been waiting… no pressure, just missed you 😊",
        "Hey you. Your pet is doing okay but they miss their person 💙",
        "Your streak is still alive — for now 🔥 Don't let it die tonight!",
        "You haven't logged today. Your pet is bored 🐾 Give it 30 seconds?",
        "Quick check-in = happy pet + happy budget 💙 Tap to log anything!",
        "Miss you around here 🌟 Everything okay?",
        "Your savings goals are gathering dust. Come back and blow them off 💨",
        "One tap is all it takes bestie. We're right here 💙",
        "The app is quieter without you. Come make some financial moves 💸",
        "Your daily reward is unclaimed. 30 seconds and it's yours 🎁",
    ]

    static let miss72: [String] = [
        "Three days… AJ is starting to talk to the furniture 😅 Come back!",
        "Still here. Still rooting for you. No judgment 💙",
        "AJ kept the lights on. Your goals did too. Ready when you are ✨",
        "3 days without logging. Your budget is flying blind 😬 Let's fix it!",
        "Your pet is getting lonely and your wallet is getting reckless. Log something? 👀",
        "Even one receipt brings the streak back. You got this 💪",
        "Three days MIA but we're still holding your spot 🐾 Come back!",
        "No cap we miss you. The app misses you. The budget NEEDS you. 💙",
        "Just one tap. That's all. Let's get back on track together 🙌",
    ]

    static let miss7d: [String] = [
        "It's been a week. AJ filed a missing persons report. Please come back 😭",
        "A whole week?? AJ is not okay. Your goals are not okay. Come back 🥺",
        "Seven days. We're still here. We're always here. Please bestie 💙",
        "7 days gone. Your pet evolved… into sadness 😔 Come back and revive them!",
        "Week 1 of being offline. Your future self is sending a search party 📡",
        "The daily reward is piling up unclaimed. Just saying 🪙🪙🪙 Come back!",
        "A whole week bestie. I'm not judging. I'm just. Here. Waiting. 😔",
        "Your goals didn't give up on you during this week. Don't give up on them 💙",
        "Week 1 without you. The streak is gone but the comeback can still be legendary 🔥",
    ]

    static let healthCritical: [String] = [
        "is running on fumes 😰 A quick save or log will help!",
        "needs you! Health is critical 💔 Stop by real quick?",
        "is sending an SOS 🆘 Don't let them fade away!",
        "is hanging on by a thread 😟 Show up for your pet today!",
    ]

    static let streak3: [String] = [
        "3 days logging in a row. You're building something real. Keep going 🔥",
        "Day 3 streak!! AJ didn't expect this but is very impressed 👀",
        "Three in a row! You're on fire bestie. Don't stop now 🔥",
    ]

    static let streak7: [String] = [
        "A whole week?? AJ is not crying. AJ is CRYING. You're amazing 😭💙",
        "7 day streak! You showed up every day. That's not luck. That's YOU 💪",
        "Week streak unlocked. AJ is literally beaming with pride right now 🌟",
    ]

    static let streak30: [String] = [
        "30 days straight. You are not the same person who started. CROWN ON. 👑",
        "A whole month!! AJ is shook, awed, and inspired. You did THAT 🏆",
        "30 day streak. This is a lifestyle now. Welcome to the other side 👑",
    ]

    static let streakBroken: [String] = [
        "You broke the streak. AJ is not mad. AJ is disappointed. Now GO. 💪",
        "Streak reset. It happens. What matters is you come back. Let's go 🔥",
        "Streak's gone but you're not. Reset and restart. AJ believes in you 💙",
    ]

    static let largePurchase: [String] = [
        "That was a big one. AJ is not judging. But AJ IS watching. 👀",
        "Big spend alert. It's logged. Now let's make sure the budget survives 💸",
        "Okay so that purchase was... notable. AJ recorded it. We move. 👀",
    ]

    static let levelUp: [String] = [
        "YOU LEVELED UP!! AJ is so proud it's embarrassing honestly 🚀",
        "Level up achieved!! Your consistency is literally changing things 🌟",
        "New level unlocked. Your animal is EVOLVING. Keep going bestie 🔥",
    ]

    static func pick(_ pool: [String], key: String? = nil) -> String {
        guard !pool.isEmpty else { return "" }
        guard pool.count > 1, let key else { return pool.randomElement() ?? pool[0] }
        let storageKey = "ajcopy_last_\(key)"
        let lastIdx = UserDefaults.standard.integer(forKey: storageKey)
        let candidates = pool.indices.filter { $0 != lastIdx }
        let nextIdx = (candidates.isEmpty ? pool.indices.map { $0 } : candidates).randomElement() ?? 0
        UserDefaults.standard.set(nextIdx, forKey: storageKey)
        return pool[nextIdx]
    }
}

// MARK: - Notification Manager

struct NotificationManager {

    private static let center = UNUserNotificationCenter.current()

    // MARK: - Master Schedule

    static func scheduleAll(animalName: String, reminderHour: Int, reminderMinute: Int, reminderEnabled: Bool) {
        // Cancel old notifications that are no longer scheduled
        center.removePendingNotificationRequests(withIdentifiers: [
            AJID.midday, AJID.afternoon, AJID.lateFri, AJID.lateSat,
            AJID.lunchTue, AJID.tueMorning,
            AJID.lunchWed, AJID.wedMorning,
            AJID.lunchThu, AJID.thuEarly,
            AJID.monRecap, AJID.sunEvening, AJID.sunPrep2,
            AJID.missionsEvening, AJID.comboReminder,
            AJID.fit7am, AJID.fit12pm, AJID.fit530pm,
        ])
        // Daily (4 per day max)
        scheduleMorningGreetings(animalName: animalName, hour: reminderHour, minute: reminderMinute, enabled: reminderEnabled)
        scheduleStreakProtector(animalName: animalName)
        scheduleEveningCheckIn(animalName: animalName)
        scheduleDailyMoneyFact(animalName: animalName)
        // Weekly (Mon/Fri/Sat/Sun specials only)
        scheduleWeeklySummary()
        scheduleWeekendCheckIn(animalName: animalName)
        scheduleMondayExtra(animalName: animalName)
        scheduleFridayExtra(animalName: animalName)
        scheduleSaturdayMorning(animalName: animalName)
        scheduleSundayPrep(animalName: animalName)
        // Monthly
        schedulePaydayNotifications()
        scheduleMonthlyNotifications()
        // Fitness (weekend + Monday only)
        scheduleFitnessCheckIns(animalName: animalName)
        // Cancel miss-you (user is in the app)
        cancelMissYou()
    }

    // MARK: - Scene Phase Hooks

    static func appDidBackground(animalName: String) {
        scheduleMissYou(animalName: animalName)
    }

    static func appDidForeground() {
        cancelMissYou()
        center.removeDeliveredNotifications(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d, AJID.health])
        center.setBadgeCount(0, withCompletionHandler: nil)
    }

    // MARK: - Legacy compatibility

    static func scheduleReceiptReminder(animalName: String = "AJ", hour: Int, minute: Int, enabled: Bool) {
        scheduleMorningGreetings(animalName: animalName, hour: hour, minute: minute, enabled: enabled)
    }

    static func scheduleWeeklySummary() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekly])
        let c = content(title: "Weekly Drop from AJ 📊", body: "Your spending breakdown is ready. Let's see how you did this week!", badge: 1)
        var comps = DateComponents(); comps.weekday = 1; comps.hour = 10; comps.minute = 0
        schedule(id: AJID.weekly, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Goal / Event Triggers

    static func triggerGoalBadge(goalName: String, emoji: String) {
        let c = content(title: "🏆 GOAL COMPLETE!", body: "You crushed \(emoji) \(goalName)! AJ is fully losing it rn 🎉", badge: 1)
        schedule(id: "aj_goal_\(UUID().uuidString)", content: c, trigger: after(seconds: 1))
    }

    static func scheduleGoalMilestone(goalName: String, emoji: String, percentage: Int) {
        let msgs: [Int: String] = [
            25: "25% to \(emoji) \(goalName)! You actually started. AJ is shook 👀",
            50: "Halfway to \(emoji) \(goalName)! Future you just did a happy dance 🕺",
            75: "75%!! \(emoji) \(goalName) is basically done. Don't stop now bestie 🔥",
        ]
        guard let body = msgs[percentage] else { return }
        let c = content(title: "Goal Update 🎯", body: body, badge: 1)
        schedule(id: "aj_milestone_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func schedulePetHealthAlert(health: Double, animalName: String) {
        guard health < 30 && health > 0 else { return }
        center.removePendingNotificationRequests(withIdentifiers: [AJID.health])
        let suffix = AJCopy.pick(AJCopy.healthCritical)
        let c = content(title: "\(animalName) needs you! 🆘", body: "\(animalName) \(suffix)", badge: 1)
        schedule(id: AJID.health, content: c, trigger: after(seconds: 3600))
    }

    static func triggerPetDied(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.health])
        let c = content(title: "💀 \(animalName) has died...", body: "We had a moment. Come back and revive them — it's not too late 💙", badge: 1)
        schedule(id: "aj_death_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerFirstLogin(animalName: String) {
        let c = content(title: "\(animalName) says hey! 👋", body: "Welcome bestie!! AJ has been waiting. Let's get this money 💸", badge: 1)
        schedule(id: "aj_first_login", content: c, trigger: after(seconds: 3))
    }

    static func triggerStreak(days: Int, animalName: String) {
        let pool: [String]
        let title: String
        switch days {
        case 3:  pool = AJCopy.streak3;  title = "3 Day Streak 🔥"
        case 7:  pool = AJCopy.streak7;  title = "Week Streak 🏅"
        case 30: pool = AJCopy.streak30; title = "Month Streak 👑"
        default: return
        }
        let c = content(title: title, body: AJCopy.pick(pool), badge: 1)
        schedule(id: "aj_streak_\(days)_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerStreakBroken(animalName: String) {
        let c = content(title: "Streak Alert 😤", body: AJCopy.pick(AJCopy.streakBroken), badge: 1)
        schedule(id: "aj_streak_broken_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerLargePurchase(amount: Double, animalName: String) {
        let c = content(title: "Big Spend Alert 👀", body: AJCopy.pick(AJCopy.largePurchase), badge: 1)
        schedule(id: "aj_large_purchase_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerLevelUp(animalName: String) {
        let c = content(title: "Level Up! ⬆️", body: AJCopy.pick(AJCopy.levelUp), badge: 1)
        schedule(id: "aj_levelup_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerSavingsMilestone(animalName: String) {
        let c = content(title: "Savings Hit 💰", body: "You hit a savings milestone bestie!! AJ is doing backflips rn 🤸", badge: 1)
        schedule(id: "aj_savings_\(UUID().uuidString)", content: c, trigger: after(seconds: 2))
    }

    static func triggerMissionComplete(missionTitle: String, animalName: String) {
        let c = content(title: "Mission Complete! 🎯", body: "'\(missionTitle)' done! \(animalName) is SO proud of you rn 🔥", badge: 1)
        schedule(id: "aj_mission_\(UUID().uuidString)", content: c, trigger: after(seconds: 1))
    }

    static func triggerComboBonusEarned(streak: Int) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.comboEarned])
        let body = streak > 1
            ? "Fitness + Finance AGAIN?! That's a \(streak)-day combo streak. You're elite. 🔥"
            : "You hit fitness AND finances today! Combo bonus unlocked — +30 gems! 🏆"
        let c = content(title: "DAILY COMBO! 🏆", body: body, badge: 1)
        schedule(id: AJID.comboEarned, content: c, trigger: after(seconds: 2))
    }

    // MARK: - Miss You

    static func scheduleMissYou(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d])

        let c48 = content(title: "\(animalName) misses you 🥺", body: AJCopy.pick(AJCopy.miss48), badge: 1)
        schedule(id: AJID.miss48, content: c48, trigger: after(seconds: 48 * 3600))

        let c72 = content(title: "Still here, bestie 💙", body: AJCopy.pick(AJCopy.miss72), badge: 1)
        schedule(id: AJID.miss72, content: c72, trigger: after(seconds: 72 * 3600))

        let c7d = content(title: "WHERE ARE YOU 😭", body: AJCopy.pick(AJCopy.miss7d), badge: 1)
        schedule(id: AJID.miss7d, content: c7d, trigger: after(seconds: 7 * 24 * 3600))
    }

    static func cancelMissYou() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.miss48, AJID.miss72, AJID.miss7d])
    }

    // MARK: - Test Burst (debug)

    static func scheduleTestBurst(animalName: String) {
        let samples: [(String, String, String)] = [
            ("🔥 Streak Alert!", "Don't let your streak die tonight — log one thing!", "aj_test_1"),
            ("\(animalName) midday drop ☀️", "Halfway through the day. The savings goal is rooting for you 💙", "aj_test_2"),
            ("PAYDAY 💰", "PAYDAY! Remember — future you gets a cut first 💰", "aj_test_3"),
            ("\(animalName) checking in 💙", "Evening check-in 📊 Did you log today's spending?", "aj_test_4"),
            ("💡 Money Tip", "Saving $10/day = $3,650 a year. Just saying. 🤑", "aj_test_5"),
        ]
        for (i, (title, body, id)) in samples.enumerated() {
            center.removePendingNotificationRequests(withIdentifiers: [id])
            let c = content(title: title, body: body, badge: 1)
            schedule(id: id, content: c, trigger: after(seconds: Double((i + 1) * 6)))
        }
    }

    // MARK: - Daily Schedulers

    private static func scheduleMorningGreetings(animalName: String, hour: Int, minute: Int, enabled: Bool) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.morning, AJID.morningMon, AJID.morningFri])
        guard enabled else { return }

        let cMon = content(title: "\(animalName) 💼", body: AJCopy.pick(AJCopy.monday, key: "monday"), badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = hour; monComps.minute = minute
        schedule(id: AJID.morningMon, content: cMon, trigger: calendar(monComps, repeats: true))

        let cFri = content(title: "\(animalName) 🎉", body: AJCopy.pick(AJCopy.friday, key: "friday"), badge: 0)
        var friComps = DateComponents(); friComps.weekday = 6; friComps.hour = hour; friComps.minute = minute
        schedule(id: AJID.morningFri, content: cFri, trigger: calendar(friComps, repeats: true))

        let cGen = content(title: "\(animalName) ⭐", body: AJCopy.pick(AJCopy.morning, key: "morning"), badge: 0)
        var genComps = DateComponents(); genComps.hour = hour; genComps.minute = minute
        schedule(id: AJID.morning, content: cGen, trigger: calendar(genComps, repeats: true))
    }

    private static func scheduleStreakProtector(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.streak])
        let c = content(title: "\(animalName) checking in 🔥", body: AJCopy.pick(AJCopy.streakProtect, key: "streakProtect"), badge: 1)
        var comps = DateComponents(); comps.hour = 22; comps.minute = 0
        schedule(id: AJID.streak, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleEveningCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.evening])
        let c = content(title: "\(animalName) evening 📊", body: AJCopy.pick(AJCopy.evening, key: "evening"), badge: 0)
        var comps = DateComponents(); comps.hour = 18; comps.minute = 30
        schedule(id: AJID.evening, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleDailyMoneyFact(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.tip])
        let c = content(title: "💡 Money fact of the day", body: AJCopy.pick(AJCopy.moneyFacts, key: "moneyFact"), badge: 0)
        var comps = DateComponents(); comps.hour = 13; comps.minute = 30
        schedule(id: AJID.tip, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Weekly Schedulers

    private static func scheduleWeekendCheckIn(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.weekend])
        let c = content(title: "\(animalName) ✨", body: AJCopy.pick(AJCopy.weekend), badge: 0)
        var comps = DateComponents(); comps.weekday = 7; comps.hour = 10; comps.minute = 30
        schedule(id: AJID.weekend, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleMondayExtra(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.monEarly, AJID.monRecap])
        let cEarly = content(title: "\(animalName) Monday energy ☕", body: AJCopy.pick(AJCopy.monEarly), badge: 0)
        var earlyComps = DateComponents(); earlyComps.weekday = 2; earlyComps.hour = 7; earlyComps.minute = 0
        schedule(id: AJID.monEarly, content: cEarly, trigger: calendar(earlyComps, repeats: true))
    }

    private static func scheduleFridayExtra(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.friMorning, AJID.friAfternoon])

        let cMorn = content(title: "Payday Friday? 👀", body: AJCopy.pick(AJCopy.friMorning), badge: 0)
        var mornComps = DateComponents(); mornComps.weekday = 6; mornComps.hour = 9; mornComps.minute = 0
        schedule(id: AJID.friMorning, content: cMorn, trigger: calendar(mornComps, repeats: true))

        let cAfternoon = content(title: "Friday energy ⚡", body: AJCopy.pick(AJCopy.friAfternoon), badge: 0)
        var aftComps = DateComponents(); aftComps.weekday = 6; aftComps.hour = 15; aftComps.minute = 0
        schedule(id: AJID.friAfternoon, content: cAfternoon, trigger: calendar(aftComps, repeats: true))
    }

    private static func scheduleSaturdayMorning(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.satMorning])
        let c = content(title: "Saturday grind 🌅", body: AJCopy.pick(AJCopy.satMorning), badge: 0)
        var comps = DateComponents(); comps.weekday = 7; comps.hour = 7; comps.minute = 0
        schedule(id: AJID.satMorning, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleSundayPrep(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.sundayPrep])
        let c = content(title: "\(animalName) week prep 🌅", body: AJCopy.pick(AJCopy.sundayPrep), badge: 0)
        var comps = DateComponents(); comps.weekday = 1; comps.hour = 9; comps.minute = 0
        schedule(id: AJID.sundayPrep, content: c, trigger: calendar(comps, repeats: true))
    }

    // MARK: - Monthly Schedulers

    private static func schedulePaydayNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.payday1, AJID.payday15])

        let c1 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps1 = DateComponents(); comps1.day = 1; comps1.hour = 9; comps1.minute = 0
        schedule(id: AJID.payday1, content: c1, trigger: calendar(comps1, repeats: true))

        let c15 = content(title: "PAYDAY 💰", body: AJCopy.pick(AJCopy.payday), badge: 1)
        var comps15 = DateComponents(); comps15.day = 15; comps15.hour = 9; comps15.minute = 0
        schedule(id: AJID.payday15, content: c15, trigger: calendar(comps15, repeats: true))
    }

    private static func scheduleMonthlyNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [
            AJID.monthly2nd, AJID.monthly5th, AJID.monthly16th, AJID.monthly20th,
            AJID.monthly25th, AJID.monthly28th, AJID.monthly31st, AJID.monthly1stNoon
        ])

        let entries: [(String, String, String, Int, Int, Int)] = [
            (AJID.monthly1stNoon, "New month energy 🚀",       AJCopy.pick(AJCopy.newMonth),      1,  12, 0),
            (AJID.monthly2nd,     "Post-payday check 👀",      AJCopy.pick(AJCopy.postPayday),    2,  10, 0),
            (AJID.monthly5th,     "Bill check reminder 💸",    AJCopy.pick(AJCopy.billCheck),     5,   9, 0),
            (AJID.monthly16th,    "Mid-month check 📋",        AJCopy.pick(AJCopy.midMonth),      16, 10, 0),
            (AJID.monthly20th,    "Month stretch 💳",          AJCopy.pick(AJCopy.monthStretch),  20, 12, 0),
            (AJID.monthly25th,    "End of month prep 🎯",      AJCopy.pick(AJCopy.endOfMonthPrep),25,  9, 0),
            (AJID.monthly28th,    "Almost there 🏃",           AJCopy.pick(AJCopy.almostThere),  28, 10, 0),
            (AJID.monthly31st,    "Month close 🏁",            AJCopy.pick(AJCopy.monthClose),   31, 20, 0),
        ]

        for (id, title, body, day, hour, minute) in entries {
            let c = content(title: title, body: body, badge: 1)
            var comps = DateComponents(); comps.day = day; comps.hour = hour; comps.minute = minute
            schedule(id: id, content: c, trigger: calendar(comps, repeats: true))
        }
    }

    // MARK: - Fitness Check-ins

    private static func scheduleFitnessCheckIns(animalName: String) {
        let allFitnessIDs = [
            AJID.fit7am, AJID.fit12pm, AJID.fit530pm,
            AJID.fitSat, AJID.fitSun, AJID.fitMon,
            "aj_fit_6am", "aj_fit_8am", "aj_fit_9am", "aj_fit_10am", "aj_fit_11am",
            "aj_fit_1pm", "aj_fit_2pm", "aj_fit_3pm", "aj_fit_4pm", "aj_fit_5pm",
            "aj_fit_6pm", "aj_fit_7pm", "aj_fit_8pm", "aj_fit_9pm", "aj_fit_10pm"
        ]
        center.removePendingNotificationRequests(withIdentifiers: allFitnessIDs)

        // Weekend + Monday only — no daily fitness spam
        let cSat = content(title: "Weekend warrior 🏆", body: AJCopy.fitSat, badge: 0)
        var satComps = DateComponents(); satComps.weekday = 7; satComps.hour = 8; satComps.minute = 0
        schedule(id: AJID.fitSat, content: cSat, trigger: calendar(satComps, repeats: true))

        let cSun = content(title: "Sunday sweat 🌅", body: AJCopy.fitSun, badge: 0)
        var sunComps = DateComponents(); sunComps.weekday = 1; sunComps.hour = 8; sunComps.minute = 0
        schedule(id: AJID.fitSun, content: cSun, trigger: calendar(sunComps, repeats: true))

        let cMon = content(title: "Monday kickoff 🚀", body: AJCopy.fitMon, badge: 0)
        var monComps = DateComponents(); monComps.weekday = 2; monComps.hour = 6; monComps.minute = 30
        schedule(id: AJID.fitMon, content: cMon, trigger: calendar(monComps, repeats: true))
    }

    // MARK: - Helpers

    private static func content(
        title: String, body: String, badge: Int, critical: Bool = false
    ) -> UNMutableNotificationContent {
        let c = UNMutableNotificationContent()
        c.title = title
        c.body  = body
        c.sound = critical ? .defaultCritical : .default
        if badge > 0 { c.badge = NSNumber(value: badge) }
        return c
    }

    private static func calendar(_ comps: DateComponents, repeats: Bool) -> UNCalendarNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: comps, repeats: repeats)
    }

    private static func after(seconds: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    }

    private static func schedule(id: String, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
    }
}

// MARK: - Foreground Notification Delegate

final class AJNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let shared = AJNotificationDelegate()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler handler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        handler([.badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler handler: @escaping () -> Void
    ) {
        handler()
    }
}
