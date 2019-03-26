import React from 'react';
import PropTypes from 'prop-types';

const NoResults = ({ recentStolen, serialNumber }) => (
  <div className="binx-stolen-widget-list">
    <h2 className="search-fail">
      {recentStolen ? (
        <div>
          <span>
            {"We're sorry! Something went wrong and we couldn't retrieve recent results!"}
            {"We're probably working on fixing this right now, send us an email at "}
            <a href="mailto:contact@bikeindex.org">contact@bikeindex.org</a> if the problem persists
          </span>
        </div>
      ) : (
        <span>
        No stolen bikes on the Bike Index with a serial of <span className="search-query">{serialNumber}</span>
        </span>
      )}
    </h2>
  </div>
);

NoResults.propTypes = {
  recentStolen: PropTypes.bool,
  serialNumber: PropTypes.string,
};

export default NoResults;
