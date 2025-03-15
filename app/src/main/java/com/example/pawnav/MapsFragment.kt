package com.example.pawnav

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context.LOCATION_SERVICE
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import androidx.fragment.app.Fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.pawnav.databinding.FragmentMapsBinding

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.material.snackbar.Snackbar

class MapsFragment : Fragment() {

    private lateinit var binding: FragmentMapsBinding
    private var isSatelliteView = false // Default: Normal map view
    private lateinit var locationManager: LocationManager
    private lateinit var locationListener: LocationListener
    private lateinit var permissionLauncher: ActivityResultLauncher<String>
    private lateinit var mMap: GoogleMap
    private lateinit var sharedPreferences: SharedPreferences
    private var trackBoolean : Boolean? = null


    /*This function is called when the Google Map is ready.
    You can add markers, move the camera, or set event listeners inside this function.*/
    private val callback = OnMapReadyCallback { googleMap ->
        // Google Maps UI
        //googleMap.uiSettings.isMyLocationButtonEnabled = false
        googleMap.uiSettings.isZoomGesturesEnabled = true
        googleMap.uiSettings.isScrollGesturesEnabled = true
        googleMap.uiSettings.isZoomControlsEnabled = true

        mMap = googleMap


        /* val sydney = LatLng(-34.0, 151.0)
         googleMap.addMarker(MarkerOptions().position(sydney).title("Marker in Sydney"))
         googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(sydney, 15f))*/

        //requireContext() or requireActivity() : because Because OnMapReadyCallback is running
        // inside Fragment and this refers to OnMapReadyCallback here.
        locationManager = requireContext().getSystemService(LOCATION_SERVICE) as LocationManager

        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                trackBoolean = sharedPreferences.getBoolean("trackBoolean",false)
                //onLocationchanged will be used once so we can move when the location is set
                if(!trackBoolean!!){
                    val userLocation =  LatLng(location.latitude,location.longitude)
                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(userLocation,15f))
                    sharedPreferences.edit().putBoolean("trackBoolean", true).apply()
                }
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}

            override fun onProviderEnabled(provider: String) {}

            override fun onProviderDisabled(provider: String) {
                Toast.makeText(requireContext(), "Please open the GPS!", Toast.LENGTH_LONG).show()
            }
        }


        binding.btnMyLocation.setOnClickListener(){
            //location permission
            if(ContextCompat.checkSelfPermission(requireContext(),Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED){
                //request permission
                //Set the blue location point
                mMap.isMyLocationEnabled == true
                if(ActivityCompat.shouldShowRequestPermissionRationale(requireActivity(),Manifest.permission.ACCESS_FINE_LOCATION)){
                    Snackbar.make(binding.root, "Permission needed for location.",Snackbar.LENGTH_INDEFINITE).setAction("Give Permission"){
                        //request permission
                        permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                    }.show()
                }else{
                    //request permission
                    permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                }
            }else{
                //permission granted
                locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,0,0f,locationListener)

                val lastLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
                //start from the lastknown location
                if(lastLocation != null){
                    val lastUserLocation = LatLng(lastLocation.latitude,lastLocation.longitude)
                    // Add marker for user's location
                    googleMap.clear()
                    googleMap.addMarker(MarkerOptions().position(lastUserLocation).title("My Location"))
                    mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(lastUserLocation, 15f))

                }


            }
        }




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



    private fun registerLauncher(){
        permissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()){ result ->
            if(result){
                if(ContextCompat.checkSelfPermission(requireContext(),Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED){
                    //permission granted
                    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,0,0f,locationListener)
                    val lastLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
                    //start from the lastknown location
                    if(lastLocation != null){
                        val lastUserLocation = LatLng(lastLocation.latitude,lastLocation.longitude)
                        mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(lastUserLocation, 15f))

                    }
                }

            }else{
                //permission denied
                Toast.makeText(requireContext(), "Permission needed!", Toast.LENGTH_LONG).show()
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
        registerLauncher()
        sharedPreferences = requireContext().getSharedPreferences("com.example.pawnav", MODE_PRIVATE)
        trackBoolean =false
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