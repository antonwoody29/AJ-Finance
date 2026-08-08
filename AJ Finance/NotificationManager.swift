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
    // Sequential daily rotating
    static let compliment = "aj_compliment"
    static let saying     = "aj_saying"
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

    // Cycles through every item exactly once before repeating — advances one per calendar day
    static func pickSequential(_ pool: [String], key: String) -> String {
        guard !pool.isEmpty else { return "" }
        let idxKey  = "ajseq_idx_\(key)"
        let dateKey = "ajseq_date_\(key)"
        let today   = Calendar.current.startOfDay(for: Date())
        var idx     = UserDefaults.standard.integer(forKey: idxKey)
        if let last = UserDefaults.standard.object(forKey: dateKey) as? Date {
            if today > Calendar.current.startOfDay(for: last) {
                idx = (idx + 1) % pool.count
                UserDefaults.standard.set(idx, forKey: idxKey)
                UserDefaults.standard.set(today, forKey: dateKey)
            }
        } else {
            UserDefaults.standard.set(today, forKey: dateKey)
        }
        return pool[idx]
    }

    // MARK: - 600 Daily Compliments (two pools merged at scheduling time)

    static let compliments: [String] = [
        "You show up even when it's hard. That's not common. That's you. 💙",
        "The fact that you're tracking your money at all puts you ahead of most people fr.",
        "Your future self is going to thank you so many times for what you're doing right now.",
        "You've got more financial discipline than you give yourself credit for. Real talk.",
        "Every single dollar you log is proof you care about your future. That's huge.",
        "You're not just surviving — you're building something. Don't forget that.",
        "The version of you from a year ago would be impressed. I promise.",
        "You logged in today. That's not small. Consistency is everything.",
        "Other people wish they had your mindset. You just don't see it yet.",
        "You're doing the quiet work that leads to loud results. Keep going.",
        "Your money habits are genuinely getting better and you deserve to know that.",
        "The goals you set? You're actually chasing them. That's rare.",
        "You're the type of person who finishes what they start. This is proof.",
        "Most people talk about saving money. You're actually doing it. Big difference.",
        "Your dedication to your goals is one of your best qualities. Seriously.",
        "You could have quit a hundred times by now. You didn't. That says everything.",
        "You are built differently and I mean that in the best way possible. 🔥",
        "Your financial future is looking bright because of the choices you make daily.",
        "You make smart decisions more often than you think. Trust yourself more.",
        "The commitment you show to your goals is honestly inspiring.",
        "You're not perfect with money and that's okay. You're learning and that's powerful.",
        "Every time you choose savings over impulse you're investing in yourself. That counts.",
        "You're more capable than your self-doubt tells you. I see it clearly.",
        "The discipline you've built didn't happen by accident. You worked for it.",
        "You care about your financial future and that puts you in a special category.",
        "Your consistency is quiet but it's building something massive over time.",
        "You logged your spending and that one habit could literally change your life.",
        "You're the main character of your own success story. Act accordingly. 👑",
        "Most people don't track their finances. You do. Never underestimate that.",
        "You're turning small daily choices into long-term freedom. That's the play.",
        "You are someone who follows through. I just want to remind you of that.",
        "Your future is being built by your present choices and your choices are good.",
        "You deserve every win that's coming to you. You've been earning it.",
        "The patience you show with your goals is a strength most people don't have.",
        "You're making your financial life better one decision at a time. That's real.",
        "You could be doing nothing. Instead you're building something. Respect.",
        "You're the kind of person who turns hard things into habits. That's a superpower.",
        "Your goals aren't just dreams anymore — they're plans. Because of you.",
        "You've got that rare quality of actually caring about your own future. 💪",
        "Every receipt you log is a small act of self-love. Real talk.",
        "You're proving every day that you take your financial life seriously.",
        "The version of you that started this journey? You've already surpassed them.",
        "You're not waiting for your life to get better. You're making it better. Huge.",
        "Your money mindset is evolving and it shows. Keep that energy.",
        "You set a goal and you're still chasing it. That's not nothing. That's everything.",
        "You're more consistent than you think. The data doesn't lie.",
        "Financial freedom is built by people exactly like you doing exactly what you're doing.",
        "You showed up again today. That's the whole game right there.",
        "The self-awareness you have about your spending is genuinely impressive.",
        "You're not just managing money — you're building the life you actually want.",
        "Your resilience is showing. Even on tough days you come back. That's character.",
        "You make choices that align with your goals. That's rare and it's powerful.",
        "You're building real financial confidence with every decision you track.",
        "The care you put into your future is one of the most admirable things about you.",
        "You're someone who turns intention into action. That's the whole secret.",
        "Your goals are valid. Your effort is real. Your progress is happening.",
        "You didn't give up when it got hard. That's what separates you.",
        "You're learning as you go and that's exactly the right approach. Keep it up.",
        "Every good financial habit you build is a gift to your future self.",
        "You're doing this for you. That's the most powerful motivation there is.",
        "Your discipline with money is teaching you discipline in life. Pay attention to that.",
        "You have more going for you than you realize most days. I see it.",
        "The effort you put in today is compounding just like interest. Trust it.",
        "You're not behind. You're exactly where your choices have brought you. And you're growing.",
        "You chose to be intentional with your money. Most people never do.",
        "Your commitment to your goals is something to be genuinely proud of.",
        "You're doing things now that your future self will be incredibly grateful for.",
        "You could have ignored your finances. You didn't. You showed up. That matters.",
        "You're building a relationship with money that most people are too scared to start.",
        "Your ambition and your actions are finally aligned. That's when magic happens.",
        "You've already proven you can do hard things. This is just the next one.",
        "You're not just spending — you're choosing. There's a massive difference.",
        "Your awareness of where your money goes is a skill most people never develop.",
        "You're creating financial stability with every choice. It adds up. Trust it.",
        "The work you do in private is building the life you want in public.",
        "You think about tomorrow. Most people only think about right now. That's your edge.",
        "You're evolving your relationship with money and that's one of the best things you can do.",
        "Your goals are specific. Your actions are consistent. Your future is bright.",
        "You've got grit and grace and that combination is unstoppable.",
        "You're someone who learns from setbacks instead of quitting. Major.",
        "The boundaries you set with your spending are acts of self-respect.",
        "You're planting seeds right now that will grow into real financial freedom.",
        "You're not just reacting to your finances anymore — you're directing them.",
        "Every time you choose your goal over an impulse you're getting stronger.",
        "Your long-term thinking is one of your greatest assets. Don't lose it.",
        "You're in a small percentage of people who actually track their money. Stand tall.",
        "You've built habits that most people only talk about building. That's you.",
        "The quiet consistency you show is going to make noise in your results soon.",
        "You're worth every goal you've set for yourself. Believe that.",
        "Your financial self-awareness is growing every single day. That's so valuable.",
        "You made a plan. Now you're working it. That's literally all it takes.",
        "You're someone who does what needs to be done even when it's not fun. That's rare.",
        "Your perseverance through financial stress shows what you're made of.",
        "You're taking ownership of your financial life. That's empowering as hell.",
        "Every smart choice you make is a brick in the foundation of your future.",
        "You're not drifting financially. You're steering. That's everything.",
        "The version of you making these choices? They're someone to be proud of.",
        "Your goals deserve a champion and luckily you're yours.",
        "You're the energy your future needed. Keep being that person.",
        "The fact that you're here, doing this, every day — that's your character showing.",
        "You're handling your money with more intention than ever before. Growth.",
        "Every financial win — big or small — is evidence of who you're becoming.",
        "You make thoughtful choices and that is genuinely a rare superpower.",
        "You're becoming the person who achieves their goals. You're not just hoping.",
        "Your values and your spending are getting more aligned every day. That's progress.",
        "You're not perfect and you don't have to be. You just have to keep going. You do.",
        "You have more financial strength than you probably realize. Tap into it.",
        "Your awareness is your advantage. You know where you stand. Most people don't.",
        "You're building a track record of following through. That changes everything.",
        "The financial clarity you're developing is going to serve you your whole life.",
        "You're choosing your future over your present comfort regularly. That's huge.",
        "You care about where you end up and that care is turning into action. Beautiful.",
        "Your mindset about money is shifting in all the right ways. I see it.",
        "You're becoming someone who money works for. Not someone who works for money.",
        "You logged in. You tracked it. You showed up. That's the whole formula.",
        "Every day you build this habit is a day closer to your goals. Real.",
        "You're not just thinking about financial goals — you're actively chasing them.",
        "Your discipline today is your freedom tomorrow. Keep choosing it.",
        "You've got the grit to turn this around on any day. And you know it.",
        "You're doing this even when it's inconvenient. That's called character.",
        "Your financial story is still being written and right now it's a good chapter.",
        "You don't just have goals. You have a plan. And you're working it.",
        "Every decision to save instead of spend is a victory. Collect those wins.",
        "You're the kind of person who makes their life better. This is proof.",
        "You're showing up for yourself financially and that is genuinely an act of love.",
        "Your dedication is the thing that separates you. Never let anyone dim that.",
        "You're writing a financial story you'll be proud to tell one day.",
        "The patience you have with your goals is building the future you want.",
        "You don't need to be perfect. You need to be persistent. And you are.",
        "Your small daily wins are compounding into something massive. Trust the process.",
        "You're investing in yourself every time you choose your goals over your impulses.",
        "You've got everything it takes to hit every goal you've set. Everything.",
        "The habits you're building now are going to outlast any single win. That's legacy.",
        "You're not just surviving your finances anymore. You're mastering them.",
        "You're the energy this journey needed. And you haven't let it down.",
        "Your tenacity is one of the most powerful things about you. Don't forget.",
        "You're doing the work that builds the life. Day by day. That's beautiful.",
        "You chose growth over comfort today. That choice compounds. Never forget.",
        "You're building something real and sustainable. That's better than fast.",
        "Your consistency is proof of your character. And your character is exceptional.",
        "You came back. Again. That's the whole story and it's a great one.",
        "You're not just managing money — you're managing your future. That's power.",
        "Every goal you've set is a declaration of who you're becoming. Own that.",
        "You handle financial pressure with more grace than you realize.",
        "You're creating financial peace of mind one logged transaction at a time.",
        "Your growth is quiet but it's real and it's unstoppable. Keep going.",
        "You're making choices today that are going to open doors you haven't even found yet.",
        "The commitment you show every time you open this app? That's integrity.",
        "You're becoming financially unshakeable. One choice at a time.",
        "You are genuinely doing a great job. I know you need to hear that sometimes.",
        "Your financial journey is uniquely yours and you're crushing it your way.",
        "You're building something that no one can take from you. That's wealth.",
        "The effort you put in never goes unseen. Even when only you know about it.",
        "You're becoming the version of yourself you always knew you could be.",
        "Your relationship with money is healthier than it's ever been. That's growth.",
        "You're winning in ways that don't always show up immediately but they will.",
        "Every day you choose discipline is a day you choose yourself. Keep choosing.",
        "You're carrying a vision for your future and executing on it. Rare energy.",
        "Your financial habits are slowly becoming your identity. And it looks good on you.",
        "You're not where you want to be yet but you're way further than you were.",
        "The pride your future self will feel about what you're doing now? Enormous.",
        "You're someone who gets back up. And that's ultimately what wins.",
        "Your money is working harder because you're working smarter. That's real.",
        "You've got clarity on your goals. That alone makes you more likely to reach them.",
        "You're living proof that intention plus action equals results.",
        "Every financial boundary you hold is an act of serious self-respect.",
        "You're not just making a budget. You're making a life. That hits different.",
        "Your commitment to your future self is something genuinely beautiful to witness.",
        "You're out here building generational habits. Future you and future family — grateful.",
        "You're doing something most people only say they'll do someday. You're doing it now.",
        "Your financial resilience is something to be truly proud of.",
        "You're developing the kind of money mindset that changes everything. Keep going.",
        "You showed the discipline today and that is all I needed to see. Let's go. 🔥",
        "You're turning your financial life into something you can actually be proud of.",
        "Every time you log, every time you save — you're voting for who you want to become.",
        "You are so much closer to your goals than you think. Don't stop now.",
        "Your effort is real. Your progress is real. You are real for this. 💪",
        "You're building financial freedom and that's one of the most powerful things a person can do.",
        "You deserve to feel proud of the progress you've made. All of it.",
        "You're not lucky. You're consistent. And consistent beats lucky every time.",
        "Your money story is getting better every chapter. You're writing it right.",
        "You're the kind of person who sees the bigger picture. That's your superpower.",
        "You're earning trust with yourself every time you follow through. That compounds.",
        "The financial goals you've set aren't too big. You're just right for them.",
        "You're building real-world skills that school never taught. Through living. Through this.",
        "Your financial self-discipline is quietly reshaping your entire life. Pay attention.",
        "You've come so far. I know you don't always feel it but the data shows it.",
        "You bring intention to your money and that's what changes everything.",
        "You're doing the unsexy daily work that leads to the exciting life. Keep going.",
        "You've got the drive. You've got the tools. You've got the plan. You've got this.",
        "Every choice you make with your money reflects who you are. And who you are is impressive.",
        "You're not just a person with financial goals. You're a person who achieves them.",
        "Your patience with this process is going to be the thing that pays off the most.",
        "You're building wealth at whatever speed you can. And that speed is the right speed.",
        "You chose your long-term goals over short-term satisfaction. That's maturity.",
        "Your financial trajectory is pointing up and it's because of your daily choices.",
        "You're proving to yourself every day that you can be trusted with your goals.",
        "You're someone who takes financial responsibility seriously. The world needs more of you.",
        "You've got this. Not because it's easy. Because you keep doing it anyway.",
        "You're getting better with money in ways that will echo through your entire life.",
        "Your courage to face your finances honestly is one of the bravest things you do.",
        "You're not just surviving this — you're growing through it. Big difference.",
        "You're becoming someone who builds wealth instead of just spending it. That's elite.",
        "You track it. You plan it. You stick to it. You're the real deal.",
        "Your financial confidence is growing every time you make a smart choice.",
        "You're someone who takes the long view. In a world of impulse that's powerful.",
        "You're not waiting for the perfect time. You're creating the right time. Right now.",
        "Your dedication to your goals is quietly building the life you've been dreaming of.",
        "You're a financial goal achiever in the making. The making is already happening.",
        "You're doing the most important work — investing in your own future. Keep going. 💙",
        "You're crushing it in the quiet. The loud results are coming. Trust it.",
        "You have everything you need to win this. And the evidence is that you're still here.",
        "You're building a financial foundation that will support everything else in your life.",
        "You make intentional money moves and that is genuinely an act of power.",
        "Your goals are big. Your actions are consistent. That's a winning combination.",
        "You've decided to be in control of your financial life. That decision changes everything.",
        "You're creating a life of financial clarity and that's one of the greatest gifts.",
        "You're someone who shows up for themselves and that is the ultimate act of self-love.",
        "Every single step you take toward your goals matters. Including today's.",
        "Your financial discipline is contagious. Even if you can't see who's watching.",
        "You're making moves. Quiet moves. But moves that will change your whole story.",
        "You're a person of action and your finances are starting to reflect that.",
        "Your best financial days are still ahead. And you're the reason for that.",
        "You've built more momentum than you realize. Don't slow down now.",
        "You're the answer to every financial doubt you've ever had about yourself.",
        "You're living with more financial intention than most people ever will. That's real.",
        "You've got this. Not because it's certain. Because you're certain. 💙",
        "Your financial wins this month — small or large — all count. Every single one.",
        "You're making tomorrow better because of what you chose to do today.",
        "You're building the habit of winning financially. And it's working.",
        "You've got the grit, the goals, and the follow-through. That's a rare combo.",
        "You're not just setting goals — you're hitting them. And that changes who you are.",
        "Your long-game financial thinking is going to pay off in ways you can't even imagine yet.",
        "You're investing in your future with every decision you make here. That's real wealth.",
    ]

    static let compliments2: [String] = [
        "You just did something most people never do — you showed up for your finances. That's enormous.",
        "Your savings habit is forming in real time and it's going to change your life. Keep it up.",
        "The version of you that started worrying about money is already fading. Look how far you've come.",
        "You're building proof every day that you can be trusted with your future. That's powerful.",
        "Every time you open this app you're casting a vote for who you want to be. Vote wisely. You do.",
        "You make financial moves most people are too scared to make. That takes real courage.",
        "The discipline you're building with money is spilling over into every other area of your life.",
        "Your goals are not too big. You're exactly the right size for them. Keep going.",
        "You showed up for yourself today and that is the most important thing you can do.",
        "Every single person who built wealth did exactly what you're doing. Exactly this. Keep going.",
        "You deserve financial peace and you're earning it every single day you stay consistent.",
        "You're building something that goes beyond money. You're building self-trust. That's priceless.",
        "The people who don't take their finances seriously will one day wish they had started like you did.",
        "Your current effort is an investment in future peace. Never underestimate that.",
        "You handled something hard with grace today and your financial future is better because of it.",
        "You make better financial decisions every week and the compound effect of that is massive.",
        "You're the kind of person who actually follows through. The world needs more of you.",
        "You're becoming financially literate in real time and that's one of the rarest gifts you can give yourself.",
        "Nobody handed this to you. You're building it yourself. That makes it real and it makes it yours.",
        "You're creating the life you want by making choices that align with it. Daily. That's maturity.",
        "Your financial journey is not a straight line and that's okay. You're still moving forward.",
        "You checked in today. That one habit, repeated for years, will change everything for you.",
        "You're not behind. You're building. Those are very different things.",
        "Your efforts are compounding even when you can't see them yet. Trust the process.",
        "You make this look easier than it is because you've built real discipline. Own that.",
        "The self-awareness you bring to your finances every day is a genuinely rare quality.",
        "You're showing up in the quiet moments where character is actually built. I see you.",
        "What you're doing isn't glamorous but it's the real path to financial freedom. Stay on it.",
        "You've turned a stressful topic into a daily habit. That's one of the most powerful transformations a person can make.",
        "Your future self is going to look back at this exact period and call it the turning point.",
        "You make intentional choices. In a world of autopilot spending that is an actual superpower.",
        "You're not just tracking money — you're changing your identity around money. That's deep work.",
        "Every dollar you're aware of is a dollar working for you instead of against you.",
        "You have more financial courage than most people will ever develop. Use it.",
        "Your consistency is the foundation everything else gets built on. Protect it.",
        "You decided to take this seriously and now you're serious about it. That chain reaction is everything.",
        "You're becoming someone who builds things instead of just consuming them. That shifts everything.",
        "Even the days that feel like nothing are adding up to something significant. Trust it.",
        "You're doing the hard right thing over the easy wrong thing. Every time. That's integrity.",
        "You've come too far to go back to financial autopilot. Your awareness is permanent now.",
        "The care you take with your money shows how much you care about your own future. Beautiful.",
        "You are actively building the life you want. Not hoping. Building. Big difference.",
        "Your financial story has a great middle chapter happening right now. The ending is going to be incredible.",
        "You're earning your financial confidence with real effort. That kind of confidence can't be faked.",
        "You're making this work even when it's inconvenient and that's where real character is forged.",
        "Every responsible choice you make creates safety for the version of you that comes next.",
        "You're laying bricks every day. One day you'll look up and there will be a mansion where there was once just dirt.",
        "You don't need external validation for your financial progress. Your balance sheet is the validation.",
        "You're doing something genuinely difficult and making it look like your normal. That's growth.",
        "The financial habits you're building now are the kind that grandparents pass down. Legacy material.",
        "You bring intention to your spending and that's a skill very few people ever truly develop.",
        "Your awareness of your financial situation is the first step and you've been taking it consistently.",
        "You've got financial resilience that most people build only after a crisis. You built it proactively.",
        "You are someone who shows up even when they don't feel like it. That quality will pay dividends forever.",
        "The patience you demonstrate with your savings process is the same patience that wins long games.",
        "You make your financial future a priority and that decision alone separates you from the crowd.",
        "You have clarity about where your money goes and that clarity is genuine financial power.",
        "You're building the kind of financial story worth telling. And you're the one writing it.",
        "The habits you're forming will outlast any single paycheck, bonus, or windfall. They're permanent.",
        "You're taking the harder road and it's going to lead somewhere the easy road never could.",
        "You proved something to yourself today. What you proved? That you do what you say. That's rare.",
        "You're making your financial dreams less and less dependent on luck and more dependent on you.",
        "Your money is finally starting to respect you because you're respecting it first.",
        "The version of you from before this journey would be genuinely amazed by who you're becoming.",
        "You understand that financial freedom is earned slowly and you've committed to the slow road. Smart.",
        "You're not just saving money. You're saving options. Future options. That's what freedom looks like.",
        "You've turned financial stress into financial awareness and that transformation is irreversible.",
        "Every day you choose your goals, you're becoming someone whose goals choose them back.",
        "You're not waiting to be rescued financially. You're building your own rescue. That's real power.",
        "The quiet confidence you're developing about money is something that money alone can never buy.",
        "You've built a real relationship with your finances and healthy relationships take real work. You're doing it.",
        "You're not one of those people who says they'll figure it out later. You're figuring it out now.",
        "The discipline muscle you're building with money will strengthen every other discipline in your life.",
        "You have the rare quality of being honest with yourself about your finances. That's the starting point for everything.",
        "You're choosing who you want to be with every financial decision. And your choices are good ones.",
        "Your financial journey is yours alone and the way you're navigating it is genuinely impressive.",
        "You're doing something today that tomorrow-you will be grateful for. That's the whole game.",
        "You didn't choose the easiest path with your money. You chose the right one. Those are different.",
        "Your ambition is matched by your discipline. That combination is everything.",
        "You've redefined your relationship with money and that's one of the most important things a person can do.",
        "You're building momentum that will carry you through even when motivation runs out.",
        "You're in it for the long game and the long game is where all the best things happen.",
        "The effort you put in invisibly every day is going to make a very visible difference one day soon.",
        "You've got financial grit. Most people fold when it gets hard. You adjust and keep going.",
        "You hold yourself accountable without being harsh. That's emotional intelligence and financial intelligence together.",
        "Every financial lesson you learn is a lesson you only have to learn once if you pay attention. You do.",
        "You're not just managing a budget. You're managing your future. And you're doing it well.",
        "You've proven you can change your relationship with money. That proof lives in every good decision you make.",
        "You care about where you end up and that care is the engine behind every financial choice you make.",
        "You've got the two most underrated financial tools: patience and consistency. Both of which you show daily.",
        "Your financial confidence is quiet but it's real and it's growing every single day.",
        "You built better money habits in this season of your life than most people build in a lifetime.",
        "You're creating financial security with your own two hands and there is nothing more empowering than that.",
        "The progress you're making may be quiet now. But quiet progress is still progress — and it compounds.",
        "You know your numbers and knowing your numbers means your numbers know you're in charge.",
        "You've made financial wellness a part of your identity. That's not a phase — that's a lifestyle shift.",
        "You did something right with your money today. That's all it takes. One right thing at a time.",
        "You're choosing financial intentionality over financial autopilot and that choice changes everything.",
        "You're writing the kind of financial story that starts slowly and ends triumphantly. Stay in it.",
        "The fact that you track, plan, and show up for your money every day? That's extraordinary care.",
        "You are someone who earns trust with yourself daily by following through on financial commitments.",
        "Every deposit you make — whether dollars or discipline — is building something real. Don't stop.",
        "You have a clarity about your goals that most people spend their whole lives looking for.",
        "Your financial growth this period is something worth being genuinely proud of. I hope you feel it.",
        "You're making every dollar count and that's a level of intention most people never reach.",
        "You are the financial comeback story in progress. The best chapters are still being written.",
        "The dedication you bring to this every day is rare and it deserves to be recognized. You're crushing it.",
    ]

    // MARK: - 300 Daily Sayings

    static let dailySayings: [String] = [
        "A budget is telling your money where to go instead of wondering where it went.",
        "Don't save what is left after spending. Spend what is left after saving.",
        "Wealth is not about having a lot of money. It's about having a lot of options.",
        "Small amounts saved consistently always beat large amounts saved occasionally.",
        "The best time to start building wealth was yesterday. The second best time is today.",
        "Financial freedom is available to those who learn about it and work for it.",
        "Your income is not your wealth. Your savings rate is your wealth.",
        "Rich people buy assets. Middle class buys liabilities thinking they're assets.",
        "Compound interest is the eighth wonder of the world. Those who understand it earn it.",
        "Spend less than you earn. Invest the rest. Stay patient. That's it.",
        "The habit of saving is itself an education.",
        "Know what you own and know why you own it.",
        "Do not save what is left after spending. But spend what is left after saving.",
        "An investment in knowledge pays the best interest.",
        "Price is what you pay. Value is what you get.",
        "If you don't find a way to make money while you sleep you will work until you die.",
        "It's not how much money you make but how much money you keep.",
        "Never depend on a single income. Make investment to create a second source.",
        "Beware of little expenses. A small leak will sink a great ship.",
        "Buy when there's blood in the streets even if the blood is your own.",
        "The most important investment you can make is in yourself.",
        "Never spend your money before you have it.",
        "Financial peace isn't the acquisition of stuff. It's learning to live on less than you make.",
        "Too many people spend money they haven't earned to buy things they don't want to impress people they don't like.",
        "It's not your salary that makes you rich. It's your spending habits.",
        "Earn more. Spend less. Invest the difference. Repeat.",
        "The goal isn't more money. The goal is living life on your terms.",
        "Frugality is not about being cheap. It's about knowing the difference between want and need.",
        "Stop buying things you don't need with money you don't have to impress people you don't care about.",
        "The secret of getting ahead is getting started.",
        "A penny saved is a penny earned.",
        "Money grows on the tree of persistence.",
        "It is not the man who has too little but the man who craves more who is poor.",
        "Wealth is the ability to fully experience life.",
        "The more you learn the more you earn.",
        "You must gain control over your money or the lack of it will forever control you.",
        "Happiness is not in the mere possession of money. It lies in the joy of achievement.",
        "Opportunity is missed by most people because it is dressed in overalls and looks like work.",
        "Real wealth is not about money. Real wealth is having time and freedom.",
        "Making money is a skill. Keeping money is a discipline.",
        "Your net worth is directly proportional to your discipline with money.",
        "Broke people count what they spend. Wealthy people count what they save.",
        "Money is a tool. Used properly it makes something beautiful. Used wrong it makes a mess.",
        "Sacrifice today for freedom tomorrow.",
        "The key to building wealth is to invest before you spend not after.",
        "Wealth is built in silence. Broke is built on display.",
        "Never let the fear of striking out keep you from playing the game.",
        "The rich invest their time and money. The poor spend their time and money.",
        "Success is not final. Failure is not fatal. It is the courage to continue that counts.",
        "You become financially free when your passive income exceeds your expenses.",
        "Budgets are not about restricting you. They're about giving your money direction.",
        "Every dollar you spend is a vote for how you want to live.",
        "Financial literacy is not taught in schools. But it will make or break your life.",
        "The secret to wealth is simple. Find a way to do more for others than anyone else does.",
        "Your financial habits today are your financial future tomorrow.",
        "Wealth favors the patient. Poverty rewards the impulsive.",
        "The biggest lie about money is that you need more of it. You need a better relationship with it.",
        "Progress is more important than perfection in your financial journey.",
        "The road to wealth is paved with small consistent actions not giant leaps.",
        "Stop comparing your chapter one to someone else's chapter twenty.",
        "Rich people focus on making more. Poor people focus on spending less. Do both.",
        "Every master was once a disaster. Including every wealthy person you admire.",
        "Motivation gets you started. Discipline keeps you going.",
        "The best investment is the one you actually make.",
        "Play long enough and the game changes in your favor.",
        "Your money is either working for you or it's working for someone else.",
        "Stop chasing a lifestyle. Start building a foundation.",
        "Success is never owned. It is rented and the rent is due every day.",
        "Financial success is 80% behavior and 20% math.",
        "You can't change your destination overnight but you can change your direction.",
        "Slow progress is still progress. Never forget that.",
        "Do what you can with what you have where you are.",
        "The difference between rich and poor is what they do with their money in the quiet.",
        "Excellence is not a destination. It's a continuous journey that never ends.",
        "Don't count the days. Make the days count.",
        "If you're not building your dream someone will hire you to build theirs.",
        "Revenue is vanity. Profit is sanity. Cash is king.",
        "Build habits that build wealth. Wealth doesn't appear. It accumulates.",
        "The shortest path to wealth is through savings and the longest through spending.",
        "Don't work for money. Make money work for you.",
        "Every expert was once a beginner. Start now.",
        "Financial intelligence is not measured by how much you make. It's measured by how much you keep.",
        "You don't have to be great to get started but you have to get started to be great.",
        "The fastest way to double your money is to fold it over and put it back in your pocket.",
        "Hustle like you're broke even when you're not.",
        "Success is the sum of small efforts repeated day in and day out.",
        "Build your financial life like a house. Foundation first. Roof second. Décor last.",
        "Vision without execution is just a daydream.",
        "Start where you are. Use what you have. Do what you can.",
        "Patience is not the ability to wait but the ability to keep a good attitude while waiting.",
        "The goal is to die with memories not dreams.",
        "Never mistake activity for achievement. Make sure your hustle has a direction.",
        "You are one decision away from a completely different financial life.",
        "Make the most of yourself by fanning the tiny inner sparks of possibility.",
        "If it is important to you you will find a way. If not you will find an excuse.",
        "The only bad workout is the one that didn't happen. Same goes for savings.",
        "Hard times create strong savers. Strong savers create good times.",
        "Don't let yesterday use up too much of today.",
        "The secret to your future is hidden in your daily routine.",
        "The most dangerous risk of all is the risk of spending your life not doing what you want.",
        "Act as if what you do makes a difference. It does.",
        "Work hard in silence. Let your bank account make the noise.",
        "Take care of your pennies and the dollars will take care of themselves.",
        "Your financial situation is a reflection of your decisions not your destiny.",
        "Do not wait. The time will never be just right.",
        "Focus not on what your money can buy today but on what it can build tomorrow.",
        "Build a life you don't need a vacation from.",
        "Dream big. Start small. Act now.",
        "The only thing standing between you and your goal is the story you keep telling yourself.",
        "Your wealth is in your habits not your income.",
        "Think long term. Spend short term. The opposite breaks people.",
        "You don't need a new year to start fresh. You need a new mindset.",
        "When you feel like giving up remember why you started.",
        "Goals without deadlines are just wishes. Give your money a deadline.",
        "You are the CEO of your own financial life. Act like it.",
        "Temporary sacrifice leads to permanent reward.",
        "Financial independence is not about greed. It's about freedom.",
        "Your spending tells the story of your priorities. Make sure it's the story you want told.",
        "Don't save money to spend later. Save money to never have to worry later.",
        "Invest in assets not appearances.",
        "You can have anything you want but not everything you want.",
        "One of the greatest gifts you can give yourself is financial stability.",
        "Take the first step in faith. You don't have to see the whole staircase.",
        "Stop trying to keep up with the Joneses. The Joneses are in debt.",
        "You don't need to earn more to save more. You need to want less.",
        "Delayed gratification is the foundation of every great financial story.",
        "Get comfortable being uncomfortable. Growth lives there.",
        "Every financial mistake is a tuition payment for your financial education.",
        "Live below your means but within your needs.",
        "The best revenge is massive success.",
        "A goal is a dream with a deadline.",
        "Be stubborn about your goals and flexible about your methods.",
        "Wake up with determination. Go to bed with satisfaction.",
        "Chase progress not perfection.",
        "The quality of your life is determined by the quality of your decisions.",
        "If you control your wallet you control your future.",
        "It's not about having time. It's about making time for what matters.",
        "The road to financial freedom begins with a single step called a budget.",
        "Show me your spending and I'll show you your priorities.",
        "Great things never came from comfort zones.",
        "Make money work for you. That's the first rule of building wealth.",
        "The secret ingredient to financial success is starting.",
        "Don't just earn more. Keep more. Grow more.",
        "Invest in your future self. She's counting on present you.",
        "Stop spending on things that don't bring you lasting joy.",
        "Every financial decision you make is either building your future or borrowing from it.",
        "You will never always be motivated. You have to learn to be disciplined.",
        "Success is simple. Do what's right do it the right way do it right now.",
        "The greatest investment you'll ever make is the investment in yourself.",
        "Start saving now. Not when you have more. Now.",
        "Money magnifies who you already are. Make sure you like who that is.",
        "Your money is a reflection of your relationship with yourself.",
        "Set the goal. Make the plan. Do the work. Celebrate the results.",
        "Know the difference between an asset and a liability. Build one. Minimize the other.",
        "Spend on experiences not things. Things depreciate. Experiences appreciate.",
        "The purpose of a budget is not to limit you. It's to liberate you.",
        "Financial security is built in the boring daily moments. Love the boring.",
        "You earn money for life. Not just for today.",
        "Discipline is the bridge between financial goals and financial reality.",
        "Invest in yourself before anyone else gets the chance to.",
        "Make your money work as hard as you do.",
        "The best financial plan is the one you'll actually stick to.",
        "What you do consistently is who you become financially.",
        "Budget = freedom in disguise.",
        "Money habits compound exactly like interest. Build good ones.",
        "Your willingness to save today is a form of voting for who you want to become.",
        "Spend intentionally. Save relentlessly. Invest consistently.",
        "Think of savings as paying your future self first.",
        "If it doesn't align with your goals don't buy it.",
        "Every hour of work deserves to be counted and directed with purpose.",
        "Small progress adds up to big results. Never dismiss the small.",
        "Your 401k doesn't care about your latest impulse buy. But you should.",
        "The people who are crazy enough to think they can change their world actually do.",
        "Get comfortable saying no to things that don't serve your goals.",
        "Wealth is built slowly and lost quickly. Respect the slow process.",
        "Let your savings speak louder than your wants.",
        "A plan without action is a wish. An action without a plan is chaos. Do both.",
        "Make your financial decisions from your future not your present feelings.",
        "Money is a tool. Build something worth building.",
        "The financial peace you're working toward is worth every sacrifice.",
        "You didn't come this far just to come this far.",
        "Write your goals down. Revisit them. Achieve them. Repeat.",
        "The investor who stays in the game wins over the investor who plays it safe.",
        "Never confuse motion with progress.",
        "Save with purpose. Spend with intention. Invest with patience.",
        "The best time to plant a money tree was ten years ago. The second best time is now.",
        "Choose experiences over things and you'll always feel richer.",
        "Stop trying to afford your wants. Start building the life that funds them.",
        "Passive income is the quiet goal that makes the loudest difference.",
        "Every wealthy person you know built it through consistency not luck.",
        "Your wallet is either your boss or your tool. Choose.",
        "Don't wait until you have enough. Use what you have to build enough.",
        "The journey to financial freedom is paved with small decisions made daily.",
        "Financial discipline today is financial freedom tomorrow. Non-negotiable.",
        "Make a habit of saving before life reminds you why it matters.",
        "You earn money to own your time. Never forget that.",
        "Your net worth statement today is a letter to your future self.",
        "Be the investor you wish you had met ten years ago.",
        "Life is too short for financial stress. Build the cushion that buys you peace.",
        "The sacrifice you make now is the freedom you buy later.",
        "Get-rich-slow is still getting rich. And it actually works.",
        "Own your financial narrative. Write it on purpose.",
        "Every goal you achieve becomes proof that the next one is possible.",
        "You're not broke. You're pre-wealthy. Act accordingly.",
        "Your future is more important than your impulse. Choose accordingly.",
        "Don't let convenience rob you of clarity about your finances.",
        "Be patient. Be consistent. Be financially intentional. That's the whole playbook.",
        "A wealthy life is not built in a moment. It's built in the moments.",
        "The only stock you can control the fundamentals of is yourself.",
        "Track your money like your money is paying attention. Because it is.",
        "Financial security is not a destination. It's a daily practice.",
        "Let your goals drive your spending not your emotions.",
        "No one who ever hustled intentionally ended up where they started.",
        "The grind is real. The results are realer. Keep going.",
        "Live like no one else now so you can live like no one else later.",
        "Save money like your future depends on it. Because it does.",
        "Your discipline with money today is your dignity in life tomorrow.",
        "Don't be defined by what you earn. Be defined by what you keep.",
        "Luck is what happens when preparation meets opportunity. Prepare.",
        "Chase cash flow not just income.",
        "The best financial legacy you can leave is the habits you build.",
        "It doesn't matter how you start. It matters that you start.",
        "Money can't buy happiness but financial stress can steal it. Build the buffer.",
        "Work hard. Stay humble. Save quietly. Grow loudly.",
        "Your choices about money are choices about freedom. Choose wisely.",
    ]

    static let dailySayings2: [String] = [
        "You are the author of your financial story. Write something worth reading.",
        "Rich is not a salary. Rich is a habit.",
        "The first step toward financial freedom is deciding you're worthy of it.",
        "Saving money is the art of wanting less than you earn.",
        "Spend less than you make. That's the whole secret. Everything else is decoration.",
        "Financial success is not complicated. It is uncomfortable. There's a difference.",
        "Money doesn't care about your feelings. Treat it like the tool it is.",
        "The best financial decision is the one that future-you would approve of.",
        "A good budget doesn't restrict you. It reflects you.",
        "Wealth is built in the space between what you earn and what you spend.",
        "The gap between where you are and where you want to be financially is called decisions.",
        "Stop budgeting based on what you wish you had. Budget based on what you have.",
        "If your outgo exceeds your income your upkeep will become your downfall.",
        "The habit that changes everything is simply paying attention to your money.",
        "Small consistent actions compound into massive outcomes. That's not philosophy. That's math.",
        "Financial intelligence is not having all the answers. It's asking the right questions.",
        "Every financial mistake you learn from is tuition. Every one you repeat is just expensive.",
        "You cannot manage what you do not measure. Measure your money.",
        "Never let the perfect be the enemy of the good savings plan.",
        "The most powerful phrase in finance is 'I'll wait.' Use it more.",
        "Frugality is not poverty. It's freedom in a different package.",
        "Money is a river. Make sure more is flowing in than out.",
        "Your financial identity matters more than your financial knowledge.",
        "Wealth is the gap between your mindset and your marketplace.",
        "Invest in your future self because that person is going to spend a lot of time being you.",
        "The best time to build wealth was yesterday. The worst time is whenever you decide not to start.",
        "Time plus consistency plus compound interest is the only formula you need.",
        "The most dangerous debt is the one you stop worrying about.",
        "Financial freedom starts with one word: enough.",
        "Budget like you're broke even when you're not. That's how you stay not-broke.",
        "Money amplifies character. Be the character worth amplifying.",
        "The investor who does nothing often outperforms the investor who does too much.",
        "Passive income is active income that went to work so you didn't have to.",
        "A simple plan followed consistently beats a complex plan abandoned quickly.",
        "You can always earn more money. You cannot earn more time. Value accordingly.",
        "Net worth is the real scorecard. Not income. Not spending. Net worth.",
        "Discipline in finances leads to discipline in everything else. This is not a coincidence.",
        "The market rewards patience. Impatience rewards the market.",
        "Your money has to go somewhere. Make sure you're the one deciding where.",
        "Automation is the single most powerful tool in personal finance. Set it and let it grow.",
        "Pay yourself first and let the rest of your life figure itself out around that.",
        "The average millionaire has failed multiple times. Persistence is the X-factor.",
        "Money without purpose evaporates. Give every dollar a mission.",
        "Earn more. Spend less. Wait longer. That's the whole wealth formula.",
        "Financial security is worth more than financial comfort. One outlasts the other.",
        "You can't invest what you didn't save. Save first. Always.",
        "The financial advice you'll follow is the financial advice that fits your life. Find that.",
        "Giving up a latte a day saves $1,400 a year. Giving up financial awareness costs everything.",
        "A good emergency fund is the only investment that guarantees you'll never need to sell others.",
        "Comparing your finances to others is a game that has no winners. Play your own game.",
        "There's no shortcut to wealth. But there is a well-worn path. Start walking it.",
        "You are richer than you think if you count your skills, health, and relationships.",
        "Financial wellness and mental wellness are deeply connected. Take care of both.",
        "Every debt you pay off is a raise in your future monthly cash flow.",
        "The money you save is not money you give up. It's money you keep.",
        "Understanding risk does not mean avoiding it. It means pricing it correctly.",
        "Stop lending money you can't afford to lose. That's not generosity — that's self-harm.",
        "You don't need a raise to be financially better off. You need better habits.",
        "A diversified income has fewer sleepless nights than a single source of income.",
        "Invest in index funds like you invest in sleep — consistently and without drama.",
        "The best financial move is often the most boring one. Make boring moves.",
        "Every financial conversation you avoid is a financial problem you're growing.",
        "A clear goal makes a strong decision easy. Get clear on the goal first.",
        "Don't confuse being busy with being productive financially. Busyness can camouflage broke.",
        "Spend money on things that make you more capable of earning money.",
        "Knowing your spending triggers is more valuable than any budgeting app.",
        "The goal of a budget is to make your money intentional — not to make you miserable.",
        "You're always in relationship with money. Make it a healthy one.",
        "Your credit score is a trust score. Build trust with borrowed money and it opens doors.",
        "Money saved in your 20s is worth four times money saved in your 40s. That math is real.",
        "Financial literacy is the new literacy. The illiterate pay more for everything.",
        "Building wealth is slow. Losing it is fast. Act accordingly.",
        "The secret to saving more is spending less — and the secret to spending less is caring more about your goals.",
        "Not every financial win is a deposit. Sometimes a win is simply not spending.",
        "Knowing the difference between a need and a want is a graduate-level life skill.",
        "Your savings rate is the single most controllable variable in your financial outcome.",
        "The only budget that works is the one you'll actually use. Find yours.",
        "One financial boundary held for one year will reshape your entire financial life.",
        "Investing small amounts consistently humiliates large amounts invested inconsistently.",
        "A dollar saved today is a decision made tomorrow. Keep making decisions.",
        "Financial maturity is wanting fewer things more intentionally.",
        "Every rich person was once broke. Very few broke people were once rich. Notice the direction.",
        "Don't let lifestyle creep steal your wealth creation window. It's narrower than you think.",
        "The compounding of knowledge works exactly like the compounding of money. Invest in both.",
        "If you're not thinking about where your money goes it's thinking about going somewhere else.",
        "Financial clarity starts with financial honesty. Be honest with yourself.",
        "You will always find money for what you truly value. What you fund reveals your values.",
        "Owning your home is an asset. Owning more house than you need is a liability.",
        "The best hedge against an uncertain future is a fully funded emergency fund.",
        "Saving is not punishment. Saving is future pleasure, prepaid.",
        "The wealthy think in decades. The broke think in days. Train your thinking.",
        "Money talks. It usually says: you should have saved me instead of spent me.",
        "Not all debt is created equal. Some opens doors. Some locks them permanently.",
        "A spending plan is just a love letter to your future self. Write it.",
        "You either tell your money what to do or your money tells you what to do.",
        "Every financial choice is a vote for your future. Vote consistently well.",
        "Wealth comes from doing ordinary things with extraordinary consistency.",
        "Financial change doesn't start with a paycheck change. It starts with a mindset change.",
        "Your spending habits are autobiography. What story are they telling?",
        "Saving money is easy when you remember what you're saving it for.",
        "Most people are one financial habit away from a completely different life.",
        "Accountability in finance works exactly like accountability in fitness. Get a partner.",
        "Know your worth, then charge accordingly — but also save accordingly.",
        "Financial peace doesn't come from having more. It comes from needing less.",
        "Money follows focus. Focus on your goals and the money follows.",
        "The real enemy of saving isn't income. It's unconscious spending.",
        "Invest in undervalued assets: skills, relationships, and your own health.",
        "You don't need a financial advisor to start. But you need a financial intention.",
        "Every financially successful person reversed an old money story at some point. Write yours.",
        "The market doesn't care about your timeline. Your timeline needs to care about the market.",
        "Saving money creates options. Options create freedom. Freedom creates peace.",
        "Every hour you work is worth a certain amount. Spend your hours accordingly.",
        "Never let a paycheck period pass without intentional saving. Never.",
        "Financial boundaries are the most loving thing you can give yourself.",
        "Stop treating your financial future like a stranger you'll meet someday. Meet it now.",
        "The cost of financial ignorance is always higher than the cost of financial education.",
        "Being good with money is mostly about being good with yourself.",
        "Money magnifies what you already are. Work on yourself first.",
        "You deserve financial security. Go build it.",
        "The most powerful force in personal finance is deciding your money has a purpose.",
        "All financial journeys start with the same first step: looking honestly at where you are.",
        "Stop financing your lifestyle and start funding your future.",
        "Your savings account is your freedom account. Fill it like your freedom depends on it.",
        "Not spending is not deprivation. It's preparation.",
        "The most important investment return is the one you don't lose to fees, impulse, and ignorance.",
        "Financial wisdom is not what you know. It's what you do with what you know.",
        "Comparison is the thief of financial progress. Run your own race.",
        "The richest lives are not built on the biggest paychecks. They're built on the biggest discipline.",
        "You become financially free the moment your savings rate exceeds your lifestyle inflation.",
        "Every budget cycle is a new opportunity to align your spending with your values.",
        "Compound interest rewards the patient and punishes the impatient with equal precision.",
        "Your greatest financial asset is the number of years you have left to invest. Use them all.",
        "Financial goals are not limits — they're invitations to build something real.",
        "The secret to financial confidence is having enough saved that you don't fear the unexpected.",
        "Wealth without wisdom evaporates. Build both.",
        "Spend on tools that build. Save from spending that depletes. That's the whole philosophy.",
        "Most people earn enough to be wealthy. Most people spend enough to stay broke.",
        "Become the CFO of your own life. The board of directors is counting on you.",
        "You can outlearn your income. You cannot outspend it indefinitely.",
        "Financial momentum is real. Start small and watch it become unstoppable.",
        "When money stops being scary and starts being a tool you're becoming financially free.",
        "Your future self's quality of life is directly proportional to your current savings rate.",
        "Financial literacy gives you the ability to see opportunities that are invisible to others.",
        "The best financial decision you can make today is the one that limits your regret tomorrow.",
        "Investing is not gambling when it's rooted in knowledge, patience, and diversification.",
        "Money is neutral. Your habits determine whether it serves you or enslaves you.",
        "Stop trying to look rich. Start actually becoming rich. They are opposites.",
        "The discipline you build around money builds character you keep everywhere else.",
        "Slow and steady is not a consolation prize. It's the only reliable path.",
        "Your net worth is your report card. Review it regularly and study from it.",
        "The most underrated financial move: automating a small increase in savings every year.",
        "Financial independence is not a number. It's a feeling of having enough. Define enough first.",
        "Real wealth is not about what you have. It's about not needing more than you have.",
        "Build the money skills nobody taught you. They'll pay more than anything school did.",
        "The easiest way to have more money is to need less of it.",
        "You are always one decision away from starting a better financial chapter.",
        "Wealth requires a vision. Without one you'll spend your way into someone else's vision.",
        "Every time you save you are building a future you'll actually want to live in.",
        "Your best financial asset has always been, and will always be, your own earning potential.",
        "Building wealth is an inside job. It starts with what you believe money is for.",
        "When the economy is hard the habits you've built are the only thing standing between you and crisis.",
        "Finance is personal because money is personal because time is personal. Own all three.",
        "Budget cuts that hurt a little now prevent financial wounds that hurt a lot later.",
        "The first rule of building wealth: never destroy what you've already built.",
        "Delayed gratification is not a life sentence. It's a down payment on the life you actually want.",
        "Protect your savings rate the way you protect your health — like your life depends on it.",
        "The most underutilized financial strategy is simply being consistent when you don't feel like it.",
        "Rich people got rich by acting like they weren't. Broke people got broke by acting like they were.",
        "A dollar invested today is a dollar that works for you every day for the rest of your life.",
        "Every financial goal begins with believing you deserve to reach it. You do.",
        "The only difference between a financial dream and a financial plan is a deadline and daily action.",
        "Financial growth is not linear. Neither is any growth worth having. Stay the course.",
        "Every purchase decision is a life decision in disguise. Choose the life you want.",
        "Most wealth is built between 40 and 65. The decisions you make now are the foundation.",
        "Financial freedom is earned by those who refuse to let comfort steal their future.",
        "Track your net worth monthly. What gets measured gets managed. What gets managed grows.",
        "You don't have to be perfect. You just have to be directionally correct consistently.",
        "Optimizing your spending is not about deprivation. It's about intention.",
        "The life you want is on the other side of the financial habits you build today.",
        "Own your financial narrative. Nobody else will write it for you.",
        "Every dollar that leaves your hands either serves you or serves someone else's bottom line.",
        "Financial boundaries are not selfish. They are the foundation of a sustainable life.",
        "The stock market is a device for transferring money from the impatient to the patient.",
        "Money problems are solvable problems. That makes them easier than most problems in life.",
        "The best investment portfolio is diverse, low-cost, consistent, and left alone.",
        "Your money mindset is more valuable than your money amount. Fix the mindset first.",
        "When you control your spending you control your options. Options are freedom.",
        "Build the emergency fund. Not someday. Now. You can't afford not to.",
        "Spending on experiences you'll remember often beats spending on things you'll forget.",
        "Financial success is 95% about mastering yourself. The other 5% is the math.",
        "Never borrow from tomorrow's peace to fund today's comfort.",
        "Every financial boundary you hold is a vote for the person you're becoming.",
        "Start with one financial goal. Win it. Then set another. Momentum is the strategy.",
        "You were not born knowing about money. But you can learn. And learning pays forever.",
        "Silence the noise. Build the portfolio. Live the life.",
        "Be relentlessly intentional about where your money goes. Relentless.",
        "Wealth is not a destination. It's a direction. Keep heading in it.",
        "The most powerful moment in any financial journey is when you decide your future matters.",
        "Money doesn't solve money problems. Habits do.",
        "Your daily financial choices are the most powerful decisions you will ever make.",
        "Build wealth slowly on purpose. Lose it fast by accident. Choose the former.",
        "Financial literacy is a lifelong practice not a one-time lesson.",
        "If you want a different financial future you have to make different financial decisions today.",
    ]

    // MARK: - 300 Additional Money Facts

    static let additionalMoneyFacts: [String] = [
        "If you save just $5 a day starting at 25 you'll have over $150,000 by 65 at 7% growth.",
        "The average millionaire has 7 different income streams.",
        "Credit card companies make most of their profit from people who pay only the minimum.",
        "78% of Americans live paycheck to paycheck at some point — budgeting is the antidote.",
        "Increasing your savings rate by 1% per year is more impactful than a 10% raise.",
        "The average car payment in the US is now over $700/month. That's a wealth killer.",
        "People who write down their financial goals are 42% more likely to achieve them.",
        "A $4 daily coffee habit over 30 years at 7% return is $150,000+ left on the table.",
        "Emergency funds reduce financial stress by 40% even when they're never used.",
        "The richest 1% own more wealth than the bottom 50% combined globally.",
        "Index funds outperform actively managed funds 80–90% of the time over 20 years.",
        "The average American has a savings rate of about 4–8%. Top savers save 20–50%.",
        "Automating savings removes the temptation to spend and increases saving by 60%.",
        "Living below your means is more important than earning above average.",
        "A 1% difference in investment fees over 30 years can cost you tens of thousands.",
        "People who have a financial advisor accumulate 3x more wealth on average.",
        "Buying a new car every 3 years vs every 10 years can cost over $500,000 in lifetime wealth.",
        "The wealth gap between homeowners and renters in the US is nearly 40:1.",
        "Paying yourself first — before any bills — is the most effective budgeting strategy.",
        "53% of Americans couldn't cover a $400 emergency without borrowing money.",
        "Investing $100/month starting at 20 returns more than $1000/month starting at 40.",
        "High-interest debt is mathematically worse than investing. Pay it off first.",
        "The 50/30/20 rule: 50% needs, 30% wants, 20% savings. Simple and effective.",
        "Subscription creep costs the average person $237/month they don't realize they're spending.",
        "A FICO score above 750 saves you tens of thousands in lifetime interest.",
        "Retail therapy has a documented rebound effect — you often feel worse after the purchase.",
        "The wealthiest 10% of Americans own 89% of all stocks.",
        "Dollar-cost averaging reduces the risk of investing at the wrong time by 60%.",
        "People who track their spending save an average of 20% more than those who don't.",
        "The Rule of 72: divide 72 by your interest rate to see how long to double your money.",
        "Roth IRA withdrawals in retirement are tax-free — one of the best legal tax advantages.",
        "The average cost of raising a child in the US is over $300,000 — financial planning matters.",
        "Inflation of 3% means your money loses half its value in 24 years if uninvested.",
        "Credit card interest rates average 20%+ — no investment reliably beats that return.",
        "The top 3 causes of financial stress are debt, lack of savings, and no budget.",
        "Couples who discuss money weekly fight about it 76% less than those who don't.",
        "Buying in bulk saves money only on things you actually use — otherwise it's just waste.",
        "The average American spends more on interest payments than on groceries.",
        "Financial stress is the #1 cause of divorce in the US.",
        "People with a written budget have a 90% higher chance of meeting their financial goals.",
        "Compound interest needs time more than it needs large amounts. Start small. Start now.",
        "A $10,000 debt at 24% APR will cost you $24,000 to pay off if you pay minimums.",
        "High earners who don't invest still end up with less than moderate earners who do.",
        "The average millionaire saves 20% or more of their income.",
        "Investing in the S&P 500 for any 20-year period in history has been profitable.",
        "Side hustles that generate $500/month invested can build $1M+ over a career.",
        "People who review their finances weekly accumulate 3x more savings in 5 years.",
        "The psychological pain of losing $100 is twice as powerful as the joy of gaining $100.",
        "Buying generic brands saves an average of 30–40% on groceries per year.",
        "Most lottery winners are broke within 5 years — income without habits doesn't last.",
        "Time in the market always beats timing the market for long-term investors.",
        "The median retirement savings for Americans over 60 is under $90,000.",
        "Starting a Roth IRA at 22 vs 32 can result in $400,000 more at retirement.",
        "Social comparison is the biggest driver of lifestyle inflation — the silent wealth killer.",
        "Emergency funds should cover 3–6 months of expenses, not income.",
        "The average American earns $1.7M over their lifetime — most won't have $250k saved.",
        "Eating out vs cooking at home costs 5–10x more per meal on average.",
        "Net worth — not income — is the real measure of financial health.",
        "People who review their credit reports regularly catch an average of 3 errors per year.",
        "The average person spends 7 years of their life working to pay for things they don't need.",
        "A $500 monthly investment at 8% return becomes $1.7M over 40 years.",
        "Buying a house is not always better than renting — it depends on your local market.",
        "Financial literacy has a direct correlation with better mental health outcomes.",
        "Wealth built slowly is more durable than wealth built quickly.",
        "70% of wealthy people report reading 30+ minutes per day about finance or self-improvement.",
        "The poverty trap is often a cycle of high fees on small amounts — banks charge more when you have less.",
        "The best hedge against inflation is owning assets that grow with or faster than inflation.",
        "The average American spends $18,000/year on non-essential items.",
        "Pre-commitment strategies — like automatic transfers — are 80% more effective than willpower alone.",
        "Financial advisors recommend keeping housing costs under 30% of gross income.",
        "The money habit that predicts wealth most strongly is not income — it's savings rate.",
        "People who max their 401k employer match but ignore it elsewhere leave 50% free money behind.",
        "Micro-investing apps have brought millions of first-time investors into the market.",
        "The average American pays $1,000+ per year in banking fees — many easily avoidable.",
        "HSA accounts are triple tax-advantaged — possibly the best savings vehicle in the US.",
        "The national savings rate in the US dropped from 17% in the 1970s to under 5% by the 2000s.",
        "A single $1,000 investment in the S&P 500 in 2000 would be worth over $5,000 today.",
        "People who invest in tax-advantaged accounts first save $500,000+ in lifetime taxes on average.",
        "The financial decisions you make in your 20s have 10x the impact of those in your 40s.",
        "You can negotiate almost everything — rent, salary, medical bills, interest rates.",
        "Credit unions offer better rates than banks 85% of the time on loans and savings.",
        "The average person can reduce their monthly expenses by 15% simply by reviewing bank statements.",
        "Debt avalanche method (pay highest interest first) saves more money. Debt snowball builds momentum.",
        "Wealthy people tend to drive used reliable cars. The appearance of wealth is not wealth.",
        "Having a clear vision for your financial future increases saving behavior by 72%.",
        "90% of people who win financial freedom cite budgeting as the turning point.",
        "The mental burden of debt lowers IQ performance by a measurable amount in studies.",
        "People in their 20s who contribute to retirement accounts work an average of 7 years less.",
        "The wealth of experience vs things: experiences provide lasting happiness; things plateau quickly.",
        "A $20,000 car loan at 7% for 5 years costs $23,834 total — $3,834 in interest alone.",
        "Americans who take 401k loans lose an average of $30,000 in long-term wealth.",
        "Side income from passion projects has a 60% higher retention rate than traditional second jobs.",
        "Spending under stress leads to an average of 32% more impulsive purchases.",
        "Making a grocery list and sticking to it saves an average of $1,560 per year.",
        "The difference between a millionaire and everyone else is often just 20 years of $500/month.",
        "People who meal prep weekly save an average of $2,000 per year on food.",
        "Behavioral finance shows that people value money they've saved more than money they've earned.",
        "Setting a 24-hour waiting rule before purchases over $100 eliminates 80% of impulse buys.",
        "Interest rate math is one of the most powerful and underused tools in personal finance.",
        "Paying off a 20% APR credit card is equivalent to earning a guaranteed 20% return.",
        "The average American will spend $1.2M on housing over their lifetime.",
        "People with high emotional intelligence make significantly better financial decisions on average.",
        "Having 3 months of expenses in savings reduces the likelihood of high-interest borrowing by 70%.",
        "The gap between financial education and financial behavior is called the knowing-doing gap.",
        "People underestimate recurring expenses by 40% and overestimate one-time savings by 50%.",
        "Your current spending patterns, if continued, will determine your financial outcome in 10 years.",
        "The average mortgage interest paid over 30 years can exceed the original loan amount.",
        "Health insurance gaps cost Americans an average of $12,000+ in lifetime unexpected medical costs.",
        "Financial mistakes are expensive. Financial education is cheap. The math is clear.",
        "The wealthiest generation in history built their money through index funds and consistency.",
        "The market has always recovered from every crash in history. Patience is the winning strategy.",
        "Fear-based financial decisions cost investors an average of 2% per year in lost returns.",
        "People overestimate how much they'll enjoy a purchase and underestimate recurring savings joy.",
        "Renting a lifestyle you can't afford destroys wealth faster than any market crash.",
        "The average car depreciates 20% in its first year and 10–15% every year after.",
        "Having a money buddy — someone to share goals with — increases financial follow-through by 65%.",
        "Real estate in most markets doubles approximately every 10–15 years.",
        "Your employer's 401k match is an instant 50–100% return. Always capture it fully.",
        "The 1% rule in real estate: monthly rent should be at least 1% of the purchase price.",
        "Reading one personal finance book per quarter has been linked to 30% better financial decisions.",
        "The habit of tracking daily spending changes saving behavior in 90 days on average.",
        "More money amplifies who you already are. Work on the who before you work on the how much.",
        "People who set specific savings goals are 2.5x more likely to achieve financial milestones.",
        "High-income earners with no savings habit end up with less than low-income earners who save consistently.",
        "Every 1% increase in your savings rate over 30 years is worth an extra $50,000+ at retirement.",
        "The hidden cost of car ownership — insurance, maintenance, gas — often exceeds the car payment.",
        "Americans spend an average of $1,497/month on non-essentials. Just 20% of that, saved, builds wealth.",
        "Tax-loss harvesting can save the average investor $2,000+ per year on investment taxes.",
        "Your most powerful financial asset is your earning potential. Invest in your skills.",
        "Studies show that people who feel gratitude about what they own spend less on new things.",
        "The real cost of a $50 dinner when you're in debt isn't $50. It's $50 + compounding interest.",
        "Building wealth is 90% mindset and 10% math. Master your psychology first.",
        "Low-cost index funds have outperformed 95% of professional fund managers over 20 years.",
        "People spend an average of $3,000/year on subscriptions they rarely use.",
        "The average American household wastes $1,500 in groceries per year through poor planning.",
        "Every financial goal needs a deadline. Without one it's just an intention.",
        "The FIRE movement proves that saving 50–70% of income can lead to retirement in under 15 years.",
        "Income inequality in the US has grown every decade since the 1970s — only personal finance closes that gap.",
        "Financial literacy reduces the likelihood of falling for scams by 80%.",
        "People who invest automatically invest 30% more than those who invest manually.",
        "The average college student graduates with $37,000 in debt — understanding interest is crucial.",
        "Negotiating your starting salary once can result in $500,000+ more in lifetime earnings.",
        "The money skill with the highest ROI is learning to say no to lifestyle inflation.",
        "The average person changes jobs 12 times in their career — keep your emergency fund portable.",
        "Having a will and estate plan reduces family financial conflicts by 80%.",
        "Budget apps increase savings compliance by 34% compared to manual budgeting.",
        "A net worth statement reviewed monthly grows 3x faster than one reviewed annually.",
        "Compound interest over 30 years on $200/month at 8% = $298,000. On $400/month = $596,000.",
        "The two worst financial decisions: buying too much house and keeping too little emergency fund.",
        "People who talk about money openly with partners are 50% less likely to experience money-related conflict.",
        "Your relationship with money was shaped by what you observed before age 10. You can reprogram it.",
        "Behavioral biases — anchoring, FOMO, herd mentality — cost average investors 3–5% per year.",
        "Financial boundaries are just as important as personal boundaries. Practice both.",
        "The money you save in your 20s is the foundation. The habits you build are the house.",
        "People who have a zero-based budget — every dollar assigned — save 20% more on average.",
        "The average American pays $15,000 in interest over their lifetime on credit cards alone.",
        "Social media fuels lifestyle inflation more than any other single factor in modern spending.",
        "Smart money moves often look boring from the outside and feel amazing from the inside.",
        "Wealthy people do not define success by what they spend. They define it by what they build.",
        "Comparing your finances to others' is comparing your chapter 3 to their chapter 20.",
        "The foundation of all wealth is the willingness to delay gratification. That's it.",
        "Building wealth is like losing weight. Slow and steady wins. Quick fixes fail.",
        "Your current expenses are your current lifestyle. Your savings are your future lifestyle.",
        "Every $100 you save today is worth $400–800 in 30 years. Every. Single. Hundred.",
        "Financial peace comes from having more than you need not from spending all you have.",
        "People who have clear money goals are 10x more likely to be financially satisfied.",
        "The wealthiest 10% got there through consistency not through complexity.",
        "Budgeting is not about restriction. It's about alignment between your values and your wallet.",
        "The best way to get a raise is to become irreplaceable and then ask for one.",
        "Automating investments removes emotion from the equation. Emotion is the wealth killer.",
        "Investing in your health now saves enormous healthcare costs later. The ROI is real.",
        "Debt is not inherently bad. Unmanaged debt is. Know the difference.",
        "The average American reaches peak earning power between 45 and 54. Plan backwards from there.",
        "Most financial mistakes aren't about money. They're about emotions. Master the feelings.",
        "Everything great in personal finance starts with knowing exactly where your money goes.",
        "You don't need a financial advisor to start investing. You need one to optimize it.",
        "The biggest risk in personal finance is doing nothing and hoping things improve on their own.",
        "The people who change their financial lives permanently change their daily habits first.",
        "The biggest financial return in your life is the tax on your income you never have to pay.",
        "Checking your bank account daily for one year changes your financial behavior permanently.",
        "The average credit score in the US is 714. A score of 750+ unlocks the best rates.",
        "Living on last month's income — one month ahead — is one of the most powerful budgeting moves.",
        "Impulse purchases are 80% less likely when you implement a 48-hour waiting rule.",
        "A rich life is not the most expensive life. It's the life most aligned with your values.",
        "The safest financial investment is knowledge about how money actually works.",
        "Money talks and it usually says goodbye when you're not paying attention.",
        "Frugal doesn't mean cheap. It means knowing the difference between cost and value.",
        "Your savings account is your future freedom fund. Treat it like your most important account.",
        "Spend on what you value. Ruthlessly cut what you don't. That's financial wisdom.",
        "People who start late saving can make up the gap with higher savings rates and lower fees.",
        "The most expensive words in personal finance are I'll start saving next month.",
        "One year of aggressive saving can fund years of less financial stress. The math works.",
        "Investing in tax-advantaged accounts before taxable ones saves an average of $10,000 in taxes.",
        "The snowball effect of good money habits: one good habit leads to three more. Start the chain.",
        "The stock market goes up and down short term. But it only goes up long term. Stay in it.",
        "You become what you repeatedly do financially. So do your money habits deliberately.",
        "Most people overestimate what they need to start investing. You can start with $1.",
        "Time is the one thing money cannot buy back. Use it to build financial security.",
        "The math of compound interest is the closest thing to a money cheat code that exists.",
        "Wealthy people build systems. Everyone else relies on motivation.",
        "Financial regret peaks at 55. Financial confidence peaks at 45 for those who planned early.",
        "Your financial health is the foundation under everything else in your life. Guard it.",
        "The most dangerous financial advice is that things will work out without a plan.",
        "The more you know about compound interest the more you hate debt and love savings.",
        "One of the most underrated wealth-building moves is buying less house than you qualify for.",
        "Money decisions made when hungry, tired, or stressed are almost always wrong. Wait.",
        "The top earners in every field got there through deliberate practice. Finance is no different.",
        "Every time you pay cash for something you otherwise would have financed you save the interest.",
        "Sustainable financial habits outlast every financial crisis, recession, and market crash.",
        "The average wealthy person in America became wealthy slowly over decades of consistent behavior.",
        "Having a clear why for your financial goals increases the probability of achieving them by 3x.",
        "People who understand the time value of money make fundamentally better financial decisions.",
        "One of the most powerful phrases in personal finance: I can't afford it. (Even when you can.)",
        "The compound effect of tracking: people who track spending for 90 days change their habits for life.",
        "Financial independence is not about retiring early. It's about having the choice.",
        "The average person will earn $2.5M in their lifetime. Your job is to keep as much as possible.",
        "Emergency funds aren't pessimistic. They're optimistic — optimistic that you can handle anything.",
    ]

    // MARK: - 300 More Money Facts

    static let additionalMoneyFacts2: [String] = [
        "The US personal savings rate peaked at 17% in the 1970s and has hovered near 4% since 2015.",
        "Over 90% of millionaires got there through real estate and index fund investing — not speculation.",
        "Financially literate people retire 3 years earlier on average than financially illiterate ones.",
        "People who negotiate their starting salary earn an average of $5,000 more per year from day one.",
        "The average American will pay $279,000 in mortgage interest over a 30-year loan.",
        "Overdraft fees cost American consumers over $15 billion per year — all preventable with awareness.",
        "36% of Americans have more credit card debt than emergency savings.",
        "Side income earners report 40% less financial stress than those with a single income source.",
        "The FICO credit score system was introduced in 1989 and now affects billions of financial decisions daily.",
        "72% of Americans say money is a significant source of stress. Savings and budgeting reduce this by half.",
        "People who write their financial goals down achieve them at a rate 42% higher than those who don't.",
        "Investing $1,000 per year starting at 22 produces more wealth than investing $2,000 starting at 32.",
        "The average cost of a single missed retirement contribution compounded over 30 years is $15,000.",
        "Grocery delivery apps cost an average of 30% more than in-store shopping when you include fees and tips.",
        "A 2% fee on an investment fund can cost you 40% of your final portfolio value over 40 years.",
        "The first year of homeownership costs an average of $10,000 more than buyers anticipate.",
        "Credit card minimum payments are designed to keep you in debt as long as mathematically possible.",
        "Women invest less than men but earn better returns on average — largely due to less frequent trading.",
        "Americans spend an average of $1,100 per year on clothing they rarely wear.",
        "The average person clicks 'agree' on financial terms without reading them 93% of the time.",
        "Couples who budget together are 30% more likely to report being very happy in their relationship.",
        "The 4% rule for retirement: withdraw 4% of your portfolio per year and it should last 30+ years.",
        "People in the top 1% of wealth typically live below their means even after reaching that status.",
        "Lunch out every workday costs the average office worker $2,500 per year more than packing lunch.",
        "Americans lose $100 billion annually to unclaimed benefits, uncashed checks, and dormant accounts.",
        "A habit of saving just 1% more per year starting at 25 can add $180,000+ to retirement savings.",
        "Real estate has outpaced inflation by an average of 1.1% per year over the past century.",
        "The average 401k balance for Americans aged 60–69 is $182,000 — far below what most need.",
        "High earners who move to lower cost-of-living areas can increase their effective wealth by 40%.",
        "34% of Americans have no savings at all — not even $100 in a dedicated savings account.",
        "The average American spends $233 per month on impulse purchases — nearly $2,800 per year.",
        "Renting a car is statistically cheaper than owning a car for people who drive fewer than 10,000 miles per year.",
        "The first $10,000 in retirement savings is the hardest. After that, momentum builds significantly.",
        "Target-date retirement funds charge lower fees on average and outperform most actively managed alternatives.",
        "The median net worth of Americans aged 35–44 is only $91,000 — largely due to debt and no savings habit.",
        "Teaching children about money before age 10 significantly improves their financial outcomes as adults.",
        "A 5% savings rate increase from age 25 to 35 has the same retirement impact as working an extra 7 years.",
        "Inflation silently erodes purchasing power by 2–4% per year — uninvested cash loses value constantly.",
        "The wealthiest Americans hold just 9% of their wealth in cash — the rest is in productive assets.",
        "Americans spend 10× more on alcohol annually than on financial education.",
        "Financial stress costs US employers $250 billion per year in lost productivity.",
        "The wealth gap between those with college degrees and those without has doubled in the last 30 years.",
        "One in three Americans will live paycheck to paycheck at some point regardless of income level.",
        "Good financial habits are contagious — people who associate with savers save more themselves.",
        "Americans collectively hold $17.5 trillion in household debt — a record as of 2024.",
        "People who review their finances weekly report 55% higher financial satisfaction.",
        "Debit card users spend on average 12–18% less than credit card users on the same purchases.",
        "The average financial advisor fee is 1% of assets under management — check yours, it may be higher.",
        "Tax-loss harvesting can boost after-tax returns by 0.5–1.5% per year — a significant edge over time.",
        "Americans pay $32 billion per year in late fees — all preventable through automation.",
        "Buying refurbished electronics saves 30–50% with minimal quality difference for most consumers.",
        "Micro-investing platforms have collectively brought over 10 million new investors into the market.",
        "People who max their HSA and invest the balance can accumulate $500,000+ in tax-free healthcare wealth.",
        "The average return on a home renovation is only 63 cents per dollar spent — rarely improves net worth.",
        "Becoming a homeowner is the single largest wealth-building event for most middle-class Americans.",
        "Americans spend $640 billion per year on entertainment — more than they save in employer-matched 401ks.",
        "The top 3 financial regrets of Americans over 60: not saving earlier, taking on too much debt, not investing.",
        "People who set and review a monthly budget spend 23% less than those who don't.",
        "Financial optimism — believing things will improve — is one of the strongest predictors of wealth building.",
        "The average car is used only 4% of the time, making it one of the least efficient assets a family owns.",
        "Having clear short-term financial goals is more effective at building habits than long-term goals alone.",
        "Americans with financial advisors have a median net worth 3.9× higher than those without — though some of that is selection bias.",
        "The return on paying off a 7% debt is a guaranteed 7% — often beating market averages after tax.",
        "67% of Americans say they avoid looking at their finances because it causes anxiety.",
        "Cash-back credit cards earn users an average of $600 per year — only when paid in full every month.",
        "The ability to distinguish between an asset and a liability is the foundation of all wealth building.",
        "Most lottery winners would have been wealthier by investing the ticket cost over 30 years.",
        "The average American household pays $1,200 per year in bank fees that could be eliminated by switching banks.",
        "People who name their savings goals ('vacation fund,' 'house down payment') save 30% faster.",
        "Buying the dip in a bear market has historically produced the highest long-term returns.",
        "The richest decade of your financial life is statistically your 50s — but only if you prepared in your 30s.",
        "87% of financial conflicts in marriages come from differences in spending values, not income levels.",
        "The single greatest risk to long-term wealth is panic-selling during a market downturn.",
        "Americans spend 3× more on interest payments than on personal savings — a dangerous ratio.",
        "Frugal behavior has been shown to increase life satisfaction — but only when it's values-driven, not fear-driven.",
        "Personal finance is 20% knowledge and 80% behavior. Behavior is the variable you can actually control.",
        "People who automate savings contribute 50–65% more per year than those who transfer manually.",
        "A 1% annual savings increase starting at 25 results in over $300,000 more at retirement.",
        "The average return on investing in your own education is 15%+ annually — one of the best investments.",
        "Financial stress shortens lifespans. Building savings literally extends your life.",
        "The gap between rich and middle class is primarily a gap in financial habits formed before age 40.",
        "US consumer credit card debt surpassed $1 trillion for the first time in 2023.",
        "The average American over 60 has less than 8 months of living expenses saved.",
        "You don't need to earn more to save more if you spend with more intention.",
        "Rebalancing your investment portfolio once per year improves long-term returns by 0.5–1%.",
        "The average financial therapist reports that 85% of money problems are rooted in emotional patterns.",
        "People who discuss money with their children weekly raise financially confident adults at twice the rate.",
        "The interest you pay on credit cards could fund 3–5 vacations per year if redirected to savings.",
        "Americans leave $24 billion in employer 401k matches uncaptured every single year.",
        "The average American saves only 15% of what financial planners recommend for a comfortable retirement.",
        "Behavioral biases — loss aversion, overconfidence, recency bias — reduce investment returns by 2–4% annually.",
        "In a 2024 survey, 79% of Americans said they wish they had learned more about money in school.",
        "Paying biweekly instead of monthly on a mortgage saves 4–6 years of payments on a 30-year loan.",
        "The average American spends $3,400 per year on clothing — mostly items worn fewer than 5 times.",
        "A net worth statement done once per month produces 3× more financial progress than one done annually.",
        "In most US states, negotiating medical bills directly results in 20–40% reductions for uninsured patients.",
        "The worst financial time to panic is also the best financial time to invest. Bear markets build wealth.",
        "People who have financial mentors accumulate 2.4× more wealth than those who navigate alone.",
        "An extra $100/month in savings at age 30 is worth approximately $400,000 by retirement.",
        "The average American couple spends $30,000 on their wedding — for a 1-day event. It deserves scrutiny.",
        "Millennials hold less real estate than any previous generation at the same age due to student debt and housing costs.",
        "The most financially dangerous phrase is 'I'll start saving when…' Nothing fills that blank fast enough.",
        "Financial independence is defined differently for everyone. Define yours before you try to reach it.",
        "One in five Americans have zero investment accounts. Zero. That group is falling further behind every year.",
        "The median wealth of white families in the US is 8× that of Black families — a structural gap requiring intentional savings.",
        "High earners who buy status symbols outspend their peers and underperform them financially by 70.",
        "Being an informed consumer saves an average of $4,000–$8,000 per year compared to impulsive spending.",
        "FIRE (Financial Independence Retire Early) adherents save 50–70% of income and often retire before 45.",
        "The interest rate on student loans has cost American borrowers $55 billion more per year than the principal.",
        "Americans who use budgeting apps are 26% more likely to be satisfied with their current financial situation.",
        "A $500 car repair fund eliminates the need for a credit card for most unexpected automotive expenses.",
        "Financially successful people are 3× more likely to have read a personal finance book in the past year.",
        "73% of Americans wish someone had taught them about money management when they were younger.",
        "Investing $50/week starting at 18 produces more wealth at 65 than $200/week starting at 35.",
        "The wealth of the top 10% grew 70% between 2019 and 2024. The bottom 50% grew 39% — faster but from less.",
        "The most powerful financial advice from the ultra-wealthy: live like you're still broke. Even when you're not.",
        "Every year you delay saving for retirement you need to save 3× as much to catch up.",
        "Americans collectively spend $500 billion per year on things they didn't plan to buy.",
        "The average person checks their social media 96 times per day. The average person checks their finances never.",
        "You cannot outsave a spending problem — but you can outsave many income problems.",
        "The average American spends 3% of income on subscriptions they've forgotten about.",
        "Creating a personal financial policy statement — your rules for money — reduces impulsive decisions by 60%.",
        "People who have a written will and estate plan experience 72% less family financial conflict after death.",
        "The financial return of exercise is enormous: lower healthcare costs, higher productivity, longer earning years.",
        "A good bank should work for you. The wrong bank works against you. The difference is thousands of dollars.",
        "Internationally, Scandinavian countries top financial literacy rankings — and also have the highest savings rates.",
        "The S&P 500 has never delivered a negative return over any 20-year period in its history.",
        "The average financial planner charges $250–$400 per hour. A good book costs $15. Start with the book.",
        "People who track daily spending for 66 days (the average habit formation period) maintain the habit for life.",
        "The wealthiest Americans were asked what they would do differently: 91% said they'd have saved more earlier.",
        "The number one regret of retirees is not investing more aggressively when young. Not spending less.",
        "The safest investment in volatile markets is always human capital — investing in your own skills.",
        "Americans collectively have $1.9 trillion sitting in low-yield savings accounts that could be earning more.",
        "Behavioral economics shows that seeing your savings balance daily increases savings contributions by 31%.",
        "The most common mistake first-time investors make is waiting for 'the right time.' There is no right time.",
        "Happiness and wealth are related up to approximately $75,000–$100,000 income after that it plateaus.",
        "The safest bet in all of personal finance is living below your means for as long as you can.",
        "Gen Z is starting to invest earlier than any previous generation — and that advantage compounds enormously.",
        "The difference between a 6% and a 7% investment return over 40 years on $10,000 is over $100,000.",
        "People who involve their children in family budgeting raise adults with 40% higher financial confidence.",
        "Tax-advantaged accounts (401k, IRA, HSA, 529) can save the average family $300,000+ over a lifetime.",
        "Americans who refinanced at lower rates in 2020–2021 saved an average of $3,000 per year in payments.",
        "The concept of 'lifestyle creep' is the biggest silent wealth killer for high earners in their 30s and 40s.",
        "Financial stress is the leading cause of insomnia for adults under 45 in the United States.",
        "The average person spends $3–$5 per transaction in ATM fees — thousands over a lifetime.",
        "Net worth conversations are more valuable than income conversations when measuring financial health.",
        "70% of Americans plan to work in retirement because they haven't saved enough — plan to not need to.",
        "Good money habits formed before 30 have roughly 10× the impact of the same habits formed after 40.",
        "Inflation affects the poor disproportionately because food and energy — hit hardest by inflation — take a larger share.",
        "Every dollar in debt you eliminate permanently increases your monthly cash flow. Permanently.",
        "The wealth-building power of time is so strong that even a 10% savings rate started at 22 creates millionaires.",
        "Americans average 10 hours of television per week. The financially successful average 30 minutes.",
        "The opportunity cost of a $50,000 car at 30 is $500,000 in retirement savings. The math is brutal.",
        "Most people earn enough money in a lifetime to retire wealthy. The variable is what they did with it.",
        "Your income determines your lifestyle ceiling. Your savings rate determines your wealth floor. Protect the floor.",
        "The financial concept of enough is the single most liberating and most wealth-building idea you can internalize.",
        "People who pay cash experience 12–18% less buyer's remorse than those who charge the same purchase.",
        "A Roth IRA contribution at 25 grows to $22 for every $1 contributed by age 65 at 8% returns.",
        "The fastest way to improve your credit score is to pay down utilization below 10% and make on-time payments.",
        "Every dollar of debt is a dollar of future income already spent. Think about that before you borrow.",
        "The average American will change jobs 12 times. Every job change is a wealth building opportunity.",
        "Financial intelligence starts with this: every dollar that leaves your control must be leaving for a reason.",
        "The most profitable financial habit of all: paying yourself first before anyone else gets a claim.",
        "Financial success is not a secret. It's a series of unsexy decisions made consistently over decades.",
    ]
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
            AJID.compliment, AJID.saying,
        ])
        // Daily (4 per day max)
        scheduleMorningGreetings(animalName: animalName, hour: reminderHour, minute: reminderMinute, enabled: reminderEnabled)
        scheduleStreakProtector(animalName: animalName)
        scheduleEveningCheckIn(animalName: animalName)
        scheduleDailyMoneyFact(animalName: animalName)
        scheduleDailyCompliment(animalName: animalName)
        scheduleDailySaying(animalName: animalName)
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

    static func cancelStreakProtector() {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.streak])
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
        var comps = DateComponents(); comps.hour = 21; comps.minute = 0
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
        let allFacts = AJCopy.moneyFacts + AJCopy.additionalMoneyFacts + AJCopy.additionalMoneyFacts2
        let c = content(title: "💡 Money fact of the day", body: AJCopy.pickSequential(allFacts, key: "moneyFact"), badge: 0)
        var comps = DateComponents(); comps.hour = 13; comps.minute = 30
        schedule(id: AJID.tip, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleDailyCompliment(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.compliment])
        let allCompliments = AJCopy.compliments + AJCopy.compliments2
        let c = content(title: "💙 \(animalName) believes in you", body: AJCopy.pickSequential(allCompliments, key: "compliment"), badge: 0)
        var comps = DateComponents(); comps.hour = 9; comps.minute = 0
        schedule(id: AJID.compliment, content: c, trigger: calendar(comps, repeats: true))
    }

    private static func scheduleDailySaying(animalName: String) {
        center.removePendingNotificationRequests(withIdentifiers: [AJID.saying])
        let allSayings = AJCopy.dailySayings + AJCopy.dailySayings2
        let c = content(title: "✨ Daily wisdom", body: AJCopy.pickSequential(allSayings, key: "saying"), badge: 0)
        var comps = DateComponents(); comps.hour = 19; comps.minute = 0
        schedule(id: AJID.saying, content: c, trigger: calendar(comps, repeats: true))
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
