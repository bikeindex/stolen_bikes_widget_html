import React, { Component } from 'react';
import PropTypes from 'prop-types';
import searchIcon from '../icons/search.svg';
import List from './List';
import NoResults from './NoResults';
import Loading from './Loading';
import { fetchStolenNearby, fetchStolenSerial } from '../api';
import { headerHeight, defaultHeight, cacheExpiry } from '../utility';
import '../styles/stolen-widget.scss';

export default class StolenWidget extends Component {
  state = {
    results: [],
    loading: true,
    searchToken: '',
    serialNumber: '',
    recentStolen: true,
  }

  async componentDidMount() {
    let results;
    const { location, cacheResults = true, recentResults = true } = this.props;

    if (!recentResults) {
      return this.setState({ loading: false, recentStolen: false });
    }

    if (!cacheResults) {
      ({ bikes: results } = await fetchStolenNearby(location));
    } else {
      const cacheKey = `recentStolen-${location}`;
      const cached = JSON.parse(localStorage.getItem(cacheKey));
      const now = new Date().getTime();
      const expires = (now + cacheExpiry);
      const expiredAt = cached ? cached.expires : 0;

      if (now > expiredAt) {
        ({ bikes: results } = await fetchStolenNearby(location));
        const newCache = JSON.stringify({ results, expires });
        localStorage.setItem(cacheKey, newCache);
      } else {
        ({ results } = cached);
      }
    }

    return this.setState({ loading: false, results });
  }

  searchSerial = async () => {
    this.setState({ loading: true });
    const { searchToken: serialNumber } = this.state;
    const { bikes: results } = await fetchStolenSerial(serialNumber);
    this.setState({
      recentStolen: false, loading: false, results, serialNumber,
    });
  };

  onClickSearch = e => {
    e.preventDefault();
    this.searchSerial();
  };

  onSubmitSearch = e => {
    e.preventDefault();
    this.searchSerial();
  };

  onChangeSerial = e => {
    const searchToken = e.target.value;
    this.setState({ searchToken });
  };

  render() {
    const { location, height } = this.props;
    const {
      loading, serialNumber, searchToken, results, recentStolen,
    } = this.state;
    const noResults = !loading && results.length === 0 && (serialNumber || recentStolen);
    const maxHeight = (Number(height) || defaultHeight) - headerHeight;

    return (
      <div id="stolen-widget">
        <form className="topsearcher" onSubmit={this.onSubmitSearch}>
          <input
            type="text"
            value={searchToken}
            onChange={this.onChangeSerial}
            placeholder="Search for a serial number"
            disabled={loading}
          />
          <button className="subm" type="submit" onClick={this.onClickSearch}>
            <img alt="search" src={searchIcon} />
          </button>
        </form>

        <div className="binxcontainer" id="binx_list_container">
          {loading ? (
            <Loading />
          ) : noResults ? (
            <NoResults
              recentStolen={recentStolen}
              serialNumber={serialNumber}
            />
          ) : (
            <List
              results={results}
              recentStolen={recentStolen}
              serialNumber={serialNumber}
              maxHeight={maxHeight}
            />
          )}

          {!loading && recentStolen && !noResults && (
            <div className="widget-info">
              Recent reported stolen bikes
              {location && <span> near <em>{location}</em></span>}
            </div>
          )}
        </div>
      </div>
    );
  }
}

StolenWidget.propTypes = {
  cacheResults: PropTypes.bool,
  recentResults: PropTypes.bool,
  location: PropTypes.string,
  height: PropTypes.number,
};
