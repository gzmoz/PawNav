package com.example.pawnav

import androidx.fragment.app.Fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.pawnav.databinding.FragmentMapsBinding

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions

class MapsFragment : Fragment() {

    private lateinit var binding: FragmentMapsBinding
    private var isSatelliteView = false // Default: Normal map view

    /*This function is called when the Google Map is ready.
    You can add markers, move the camera, or set event listeners inside this function.*/
    private val callback = OnMapReadyCallback { googleMap ->
        // Google Maps UI
        googleMap.uiSettings.isZoomGesturesEnabled = true
        googleMap.uiSettings.isScrollGesturesEnabled = true
        googleMap.uiSettings.isZoomControlsEnabled = true

        val sydney = LatLng(-34.0, 151.0)
        googleMap.addMarker(MarkerOptions().position(sydney).title("Marker in Sydney"))
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(sydney, 15f))

        // Set up toggle button for map type switching
        binding.btnToggleMap.setOnClickListener{
            isSatelliteView = !isSatelliteView //toggle boolean

            if(isSatelliteView){
                googleMap.mapType = GoogleMap.MAP_TYPE_SATELLITE
                binding.btnToggleMap.setImageResource(R.drawable.map_icon)
            }else{
                googleMap.mapType = GoogleMap.MAP_TYPE_NORMAL
                binding.btnToggleMap.setImageResource(R.drawable.satellite_icon)
            }
        }

    }

    /*This function is responsible for creating and returning the view for the fragment.
    It inflates the fragment_maps.xml layout.*/
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = FragmentMapsBinding.inflate(inflater,container,false)
        return binding.root
    }

    /*This function is called after the view has been created.
    It is used to initialize UI elements and perform setup tasks.*/
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val mapFragment = childFragmentManager.findFragmentById(R.id.map) as SupportMapFragment?
        mapFragment?.getMapAsync(callback)
    }

}