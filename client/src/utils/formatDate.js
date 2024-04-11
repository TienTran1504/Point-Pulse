import { format } from "date-fns";

const formatDate = (isoDate) => {
  if (!isoDate) return '';

  const date = new Date(isoDate);
  return format(date, 'dd/MM/yyyy');
};

export default formatDate