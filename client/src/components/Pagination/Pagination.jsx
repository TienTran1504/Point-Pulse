import React from 'react';
import { usePagination, DOTS } from './hook/usePagination';
import classes from './styles.module.scss';

const Pagination = (props) => {
  const { onPageChange, totalCount, siblingCount = 1, currentPage, pageSize } = props;

  const paginationRange = usePagination({
    currentPage,
    totalCount,
    siblingCount,
    pageSize,
  });

  // If there are less than 2 times in pagination range we shall not render the component
  if (currentPage === 0 || paginationRange.length < 2) {
    return null;
  }

  const onNext = () => {
    onPageChange(currentPage + 1);
  };

  const onPrevious = () => {
    onPageChange(currentPage - 1);
  };

  let lastPage = paginationRange[paginationRange.length - 1];
  return (
    <ul className={classes.pagination_container}>
      {/* Left navigation arrow */}
      <li
        className={[classes.pagination_item, currentPage === 1 && classes['pagination_item--disabled']].join(' ')}
        onClick={onPrevious}
      >
        <div className={[classes.arrow, classes.arrow__left].join(' ')} />
      </li>
      {paginationRange.map((pageNumber, index) => {
        // If the pageItem is a DOT, render the DOTS unicode character
        if (pageNumber === DOTS) {
          return (
            <li key={index} className={[classes.pagination_item, classes.dots].join(' ')}>
              &#8230;
            </li>
          );
        }

        // Render our Page Pills
        return (
          <li
            key={index}
            className={[
              classes.pagination_item,
              pageNumber === currentPage && classes['pagination_item--selected'],
            ].join(' ')}
            onClick={() => onPageChange(pageNumber)}
          >
            {pageNumber}
          </li>
        );
      })}
      {/*  Right Navigation arrow */}
      <li
        className={[classes.pagination_item, currentPage === lastPage && classes['pagination_item--disabled']].join(
          ' '
        )}
        onClick={onNext}
      >
        <div className={[classes.arrow, classes.arrow__right].join(' ')} />
      </li>
    </ul>
  );
};

export default Pagination;
