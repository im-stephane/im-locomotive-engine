export function buildProps(specificPropsHash) {
  const props = {
    content: {
      site: undefined,
      page: { id: 1, contentEntryId: null }
    },
    editableElements: [],
    sections: {
      all: [],
      top: undefined,
      bottom: undefined,
      dropzone: undefined
    },
    sectionDefinitions: undefined,
    iframe: {
      loaded:       false,
      _window:      null
    }
  };

  return { ...props, ...specificPropsHash };
}

