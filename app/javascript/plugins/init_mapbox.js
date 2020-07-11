import mapboxgl from 'mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds);
};

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow); // add this

    // Create a HTML element for your custom marker
    const element = document.createElement('div');
    element.className = 'marker';
    element.style.backgroundImage = `url('${marker.image_url}')`;
    element.style.backgroundSize = 'contain';
    element.style.width = '25px';
    element.style.height = '25px';

    // Pass the element as an argument to the new marker
    new mapboxgl.Marker(element)
      .setLngLat([marker.lng, marker.lat])
      .setPopup(popup)
      .addTo(map);
  });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  // only build a map if there's a div#map to inject into
  if (!mapElement) { return; }
  // console.log("mapEl found, generate map Obj");

  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  const map = new mapboxgl.Map({
    container: mapElement,
    style: 'mapbox://styles/mapbox/light-v10',
    attributionControl: false
  });
  // console.log("map Obj generated");
  // console.log(map);
  // console.log(mapboxgl);
  map.addControl( new mapboxgl.AttributionControl(), 'bottom-right');
  map.addControl( new MapboxGeocoder({ accessToken: mapboxgl.accessToken, mapboxgl: mapboxgl }) );
  // console.log("added Controls to map Obj");

  const markers = JSON.parse(mapElement.dataset.markers);
  if (Object.keys(markers).length > 0) {
    addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);
  }
  // console.log("added Markers to map Obj");
};

export { initMapbox };
