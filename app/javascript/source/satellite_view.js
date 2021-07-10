import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';

window.addEventListener("load", () => {
    var satellite_view_element = document.getElementById(('satellite-view'))
    if (satellite_view_element != null) {
       const renderer = new THREE.WebGLRenderer();
       var width = satellite_view_element.offsetWidth - 4; // Minus 4 to account for the 2px border on both left and right
       var height = satellite_view_element.offsetHeight - 4; // Minus 4 to account for the 2px border on both top and left
       renderer.setSize(width, height);
       satellite_view_element.appendChild(renderer.domElement);

        var scene = new THREE.Scene();

        var camera = new THREE.PerspectiveCamera(75, width / height, 1, 10000);
        camera.position.set( 0, 0, 100 );
        camera.lookAt( 0, 0, 0 );

        var controls = new OrbitControls(camera, satellite_view_element);
        controls.target.set(0, 0, 0);

        const material = new THREE.LineBasicMaterial({ color: 0x0000ff });
        const points = [];
        points.push( new THREE.Vector3(- 10, 0, 0 ));
        points.push( new THREE.Vector3(0, 10, 0 ));
        points.push( new THREE.Vector3(10, 0, 0 ));
        const geometry = new THREE.BufferGeometry().setFromPoints(points);
        const line = new THREE.Line(geometry, material);
        scene.add(line);

        function animate() {
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        }

        animate();
    }
});
