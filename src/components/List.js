import React, { Fragment } from 'react';
import PropTypes from 'prop-types';
import { formatDate } from '../utility';

const List = ({
  results, recentStolen, serialNumber, maxHeight,
}) => (
  <Fragment>
    {!recentStolen && serialNumber && (
      <h2 className="search-response-info">
        Bikes with serial numbers matching <em>{serialNumber}</em>
        <span>
          ({results.length > 19 ? 'many found, showing first 20' : `${results.length} found`})
        </span>
      </h2>
    )}
    <ul style={{ maxHeight }}>
      {results.map(result => {
        const link = `https://bikeindex.org/bikes/${result.id}`;
        return (
          <li key={result.id} className={result.stolen && 'stolen'}>
            {result.thumb
              && (
              <a className="stolen-thumb" href={link} target="_blank" rel="noopener noreferrer">
                <img alt="thumb" src={result.thumb} />
              </a>
              )
            }
            <h4>
              <a href={link} target="_blank" rel="noopener noreferrer">{result.title}</a>
            </h4>
            <p>
              <span className="stolen-color">Stolen</span>
              {result.stolen_location
                && <span> from {result.stolen_location} &mdash;</span>
              }
              {result.date_stolen
                && <span className="date-stolen"> {formatDate(result.date_stolen)}</span>
              }
            </p>
            <p>
              Serial: <span className="serial-text">{result.serial}</span>
            </p>
            {!result.stolen
              && <p className="not-stolen">Bike is not marked stolen</p>
            }
          </li>
        );
      })}
    </ul>
  </Fragment>
);

List.propTypes = {
  results: PropTypes.arrayOf(PropTypes.object),
  recentStolen: PropTypes.bool,
  serialNumber: PropTypes.string,
  maxHeight: PropTypes.number,
};

export default List;
