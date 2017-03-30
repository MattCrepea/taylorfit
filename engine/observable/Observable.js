
const _events         = Symbol('events');
const _listeners      = Symbol('listeners');
const _listenerCount  = Symbol('listenerCount');

class Observable {

  constructor() {
    this[_events] = {};
    this[_listeners] = {};
    this[_listenerCount] = 0;
  }

  on(event, handler) {
    let id = this[_listenerCount] += 1;

    this[_listeners][id] = handler;

    if (!this[_events][event]) {
      this[_events][event] = [];
    }

    this[_events][event].push(id);
    return id;
  }

  removeListener(id) {
    delete this[_listeners][id];

    Object.keys(this[_events]).forEach(
      (event) => this[_events][event] = this[_events][event].filter(
        (handlerId) => handlerId !== id));
  }

  fire(event, data) {
    if (!this[_events][event]) {
      this[_events][event] = [];
    }
    this[_events][event].forEach((id) => this[_listeners][id](data));
  }

}

module.exports = Observable;