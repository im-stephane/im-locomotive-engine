import { createStore, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
import rootReducer from './reducers/index';

import ApiFactory from './services/api';
import { build as buildRoutes } from './services/routes_service';

// create an object for the default data
const { data, urls } = window.Locomotive;
const { site, page, sectionDefinitions, sections, editableElements, locale, locales, uiLocale, contentTypes } = data;

const defaultState = {
  editor: {
    changed:          false,
    pageChanged:      false, // Page Settings & SEO
    formErrors:       {},
    focusedSettingId: null,
    sectionDefinitions,
    sections,
    editableElements,
    contentTypes,
    locale,
    locales,
    uiLocale,
    urls,
    api: ApiFactory(urls, locale),
    routes: buildRoutes(page?.id, page?.contentEntryId, urls?.base)
  },
  content: {
    site: site,
    page: page
  },
  iframe: {
    loaded:   null, // null => when the editor is displayed for the first time
    _window:  null
  }
};

export default createStore(
  rootReducer,
  defaultState,
  compose(
    applyMiddleware(thunk),
    window.__REDUX_DEVTOOLS_EXTENSION__ ? window.__REDUX_DEVTOOLS_EXTENSION__() : f => f
  )
);
