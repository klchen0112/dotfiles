#!/bin/zsh

# 使用 osascript 执行 JXA 脚本
result=$(osascript -l JavaScript <<EOF
const reminders = Application('Reminders');
const lists = reminders.lists;

const today = new Date();
today.setHours(0, 0, 0, 0);

const tomorrow = new Date(today);
tomorrow.setDate(today.getDate() + 1);

let todayCount = 0;
let tomorrowCount = 0;

lists().forEach(list => {
    const remindersInList = list.reminders();
    remindersInList.forEach(reminder => {
        const dueDate = reminder.dueDate();
        if (dueDate) {
            const due = new Date(dueDate);
            due.setHours(0, 0, 0, 0);
            if (due.getTime() === today.getTime()) {
                todayCount++;
            } else if (due.getTime() === tomorrow.getTime()) {
                tomorrowCount++;
            }
        }
    });
});

JSON.stringify({ today: todayCount, tomorrow: tomorrowCount });
EOF
)

# 解析 JSON 输出
today_count=$(echo "$result" | jq '.today')
tomorrow_count=$(echo "$result" | jq '.tomorrow')

# 输出结果
echo "今天到期的提醒数量: $today_count"
echo "明天到期的提醒数量: $tomorrow_count"
