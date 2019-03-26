import React from 'react';
import { shallow, mount } from 'enzyme';
import toJson from 'enzyme-to-json';
import StolenWidget from './StolenWidget';
import * as api from '../api';
import { headerHeight } from '../utility';

jest.mock('../api');

describe('<StolenWidget /> shallow rendered', () => {
  it('matches the snapshot', () => {
    const tree = shallow(<StolenWidget />);
    expect(toJson(tree)).toMatchSnapshot();
  });

  it('accepts config props', () => {
    const wrap = shallow(
      <StolenWidget
        cacheResults
        recentResults={false}
        location="Portland, OR"
        height={400}
      />,
    );
    const { props } = wrap.instance();
    const expected = {
      cacheResults: true,
      recentResults: false,
      location: 'Portland, OR',
      height: 400,
    };
    expect(props).toEqual(expected);
  });

  it('has a disabled search input', () => {
    const wrap = shallow(<StolenWidget />);
    expect(wrap.find('.topsearcher input').is('[disabled]')).toBe(true);
  });

  it('on search input changes searchToken', () => {
    const wrap = shallow(<StolenWidget />);
    const input = wrap.find('input');
    input.simulate('change', { target: { value: 'something' } });
    expect(wrap.state('searchToken')).toEqual('something');
  });

  it('calls searchSerial when the search button is clicked', () => {
    const wrap = shallow(<StolenWidget />);
    const event = Object.assign(jest.fn(), { preventDefault: () => {} });
    const instance = wrap.instance();

    jest.spyOn(instance, 'searchSerial');
    wrap.find('button').simulate('click', event);
    expect(instance.searchSerial).toHaveBeenCalled();
  });
});

describe('<StolenWidget /> mount rendering', () => {
  it('matches the snapshot', () => {
    const tree = mount(<StolenWidget />);
    expect(toJson(tree)).toMatchSnapshot();
  });

  it('has nearby stolen bikes when recentResults is enabled', () => {
    const wrap = mount(<StolenWidget recentResults />);
    expect(wrap.state('results')).not.toHaveLength(0);
  });

  it('does not have nearby stolen bikes when recentResults is disabled', () => {
    const wrap = mount(<StolenWidget recentResults={false} />);
    expect(wrap.state('results')).toHaveLength(0);
  });

  it('uses the location option when searching', () => {
    jest.spyOn(api, 'fetchStolenNearby');
    mount(<StolenWidget location="Portland, OR" />);
    expect(api.fetchStolenNearby).toHaveBeenCalledWith('Portland, OR');
  });

  it('searches for a matching serialNumber', () => {
    const searchToken = '000111222aaa';
    jest.spyOn(api, 'fetchStolenSerial');
    const wrap = mount(<StolenWidget recentResults={false} />);
    wrap.setState({ searchToken });
    wrap.find('button').simulate('click');
    expect(api.fetchStolenSerial).toHaveBeenCalledWith(searchToken);
  });

  it('caches results in localStorage', () => {
    mount(<StolenWidget cacheResults location="Portland, OR" />);
    expect(localStorage.setItem).toHaveBeenCalled();
  });

  it('sets the maxHeight of the list', () => {
    const height = 200;
    const wrap = mount(<StolenWidget height={height} />);
    const expected = height - headerHeight;
    expect(wrap.find('List').prop('maxHeight')).toEqual(expected);
  });
});
