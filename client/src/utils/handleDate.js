function getWeeksInRange(fromDate, toDate) {
  const weeks = [];
  let currentWeekStart = getMonday(new Date(fromDate));
  while (currentWeekStart <= getMonday(new Date(toDate))) {
    const currentWeekEnd = new Date(currentWeekStart);
    currentWeekEnd.setDate(currentWeekEnd.getDate() + 6);

    const formattedWeek = `${formatFullDate(currentWeekStart)} - ${formatFullDate(currentWeekEnd)}`;
    weeks.push({ formattedWeek });

    currentWeekStart = currentWeekEnd;
    currentWeekStart.setDate(currentWeekStart.getDate() + 1);

  }

  return weeks;
}



function formatFullDate(date) {
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${year}-${month}-${day}`;
}
function formatDate(current_date) {
  const date = new Date(current_date)
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  return `${month}/${year}`;
}

function getMonday(date) {
  const day = date.getDay();
  const diff = date.getDate() - day + (day === 0 ? -6 : 1); // adjust when day is Sunday
  return new Date(date.setDate(diff));
}

function getCurrentDate() {
  const today = new Date();
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, '0'); // Thêm '0' phía trước nếu tháng chỉ có một chữ số
  const day = today.getDate().toString().padStart(2, '0'); // Thêm '0' phía trước nếu ngày chỉ có một chữ số

  const formattedDate = `${year}-${month}-${day}`;
  return formattedDate;
}

function getOneMonthAgoDate() {
  const today = new Date();

  // Lấy tháng của ngày hiện tại
  let currentMonth = today.getMonth();

  // Giảm giá trị của tháng đi 1 (để lấy tháng trước)
  currentMonth--;

  // Nếu tháng hiện tại là tháng 0 (tháng 1), điều chỉnh lại thành tháng 12 của năm trước
  if (currentMonth < 0) {
    currentMonth = 11; // Tháng 12
    today.setFullYear(today.getFullYear() - 1); // Giảm năm đi 1
  }

  // Đặt tháng mới vào đối tượng Date
  today.setMonth(currentMonth);

  // Lấy năm và tháng mới
  const year = today.getFullYear();
  const month = (currentMonth + 1).toString().padStart(2, '0'); // Thêm '0' phía trước nếu tháng chỉ có một chữ số
  const day = today.getDate().toString().padStart(2, '0'); // Thêm '0' phía trước nếu ngày chỉ có một chữ số

  const formattedDate = `${year}-${month}-${day}`;
  return formattedDate;
}

function getFifteenDaysAgoDate() {
  const today = new Date();

  // Lấy ngày hiện tại
  const currentDay = today.getDate();

  // Giảm giá trị của ngày đi 15 (để lấy ngày 15 ngày trước)
  const fifteenDaysAgo = currentDay - 15;

  // Đặt ngày mới vào đối tượng Date
  today.setDate(fifteenDaysAgo);

  // Lấy năm, tháng và ngày mới
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, '0'); // Thêm '0' phía trước nếu tháng chỉ có một chữ số
  const day = today.getDate().toString().padStart(2, '0'); // Thêm '0' phía trước nếu ngày chỉ có một chữ số

  const formattedDate = `${year}-${month}-${day}`;
  return formattedDate;
}

function getFifteenDaysAfterDate() {
  const today = new Date();

  // Lấy ngày hiện tại
  const currentDay = today.getDate();

  // tăng giá trị của ngày đi 15 (để lấy ngày 15 ngày sau)
  const fifteenDaysAgo = currentDay + 15;

  // Đặt ngày mới vào đối tượng Date
  today.setDate(fifteenDaysAgo);

  // Lấy năm, tháng và ngày mới
  const year = today.getFullYear();
  const month = (today.getMonth() + 1).toString().padStart(2, '0'); // Thêm '0' phía trước nếu tháng chỉ có một chữ số
  const day = today.getDate().toString().padStart(2, '0'); // Thêm '0' phía trước nếu ngày chỉ có một chữ số

  const formattedDate = `${year}-${month}-${day}`;
  return formattedDate;
}

function checkCurrentDate(formattedWeek) {
  const week = formattedWeek.split(" - ")
  // Lấy ngày hiện tại
  const currentDate = new Date();
  // Chuyển đổi ngày nhập vào thành đối tượng Date
  const inputDateObject = new Date(week[0]);
  // So sánh ngày nhập vào với ngày hiện tại
  return inputDateObject > currentDate;
}
export { formatFullDate, formatDate, getWeeksInRange, getCurrentDate, getOneMonthAgoDate, checkCurrentDate, getFifteenDaysAfterDate, getFifteenDaysAgoDate }