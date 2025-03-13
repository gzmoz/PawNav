package com.example.pawnav

import android.Manifest
import android.content.pm.PackageManager
import android.location.Geocoder
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.pawnav.databinding.FragmentLastSeenLocationBinding
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.material.snackbar.Snackbar
import java.util.Locale


class LastSeenLocationFragment : Fragment(), OnMapReadyCallback {

    private lateinit var googleMap: GoogleMap
    private lateinit var mapFragment: SupportMapFragment
    private var _binding: FragmentLastSeenLocationBinding? = null
    private lateinit var locationManager: LocationManager
    private lateinit var locationListener: LocationListener
    private lateinit var permissionLauncher: ActivityResultLauncher<String>
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding = FragmentLastSeenLocationBinding.inflate(inflater, container, false)
        val view = binding.root

        // Haritayı başlat
        mapFragment = childFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)

        registerLauncher()

        return view
    }


    override fun onMapReady(map: GoogleMap) {
        googleMap = map

        // Harita için varsayılan konum (örneğin, İstanbul)
        val defaultLocation = LatLng(41.0082, 28.9784) // İstanbul koordinatları
        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(defaultLocation, 12f))

        // Örnek bir marker ekleyelim
        googleMap.addMarker(MarkerOptions().position(defaultLocation).title("Default Location"))
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        //initialize location services
        locationManager = requireContext().getSystemService(android.content.Context.LOCATION_SERVICE) as LocationManager

        binding.btnFindLocation.setOnClickListener {
            val queryText = binding.searchView.query.toString()

            if (queryText.isNotEmpty()) {
                // Initialize the Geocoder
                // Gecoder: we can convert addresses to coordinates and coordinates to addresses.
                val geocoder = Geocoder(requireContext(), Locale.getDefault())  //Locale.getDefault(): returns the current system language and country info of the devide

                try {
                    val addressList = geocoder.getFromLocationName(queryText, 1)
                    //getFromLocationName() is a function that takes a location name (String) and returns a list of possible matching addresses.
                    //maxResults The maximum number of results to return (1 in this case → meaning we only fetch the best match).

                    if (!addressList.isNullOrEmpty()) {
                        val address = addressList[0]

                        // **Boş veya null olan değerleri atlamak için filtre uygula**
                        val parts = listOf(
                            address.subLocality,   // Neighborhood
                            address.thoroughfare,  // Street name
                            address.locality,      // City/District
                            address.adminArea      // State/Region
                        ).filterNotNull().filter { it.isNotEmpty() } // Remove null and empty values

                        val formattedAddress =
                            parts.joinToString(", ") // // Remove null and empty values

                        binding.searchView.setQuery(formattedAddress, false)
                        //Move the Google Maps camera to the found location
                        val locationLatLng = LatLng(address.latitude, address.longitude)
                        googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(locationLatLng, 15f))

                        // add marker
                        googleMap.clear() // clear the previous markers
                        googleMap.addMarker(MarkerOptions().position(locationLatLng).title(formattedAddress))
                    } else {
                        binding.searchView.setQuery("Address is not found", false)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    binding.searchView.setQuery("An error occurred", false)
                }
            }
        }

        binding.btnAddLocation.setOnClickListener {
            //bundle: a data structure used to carry, store and transfer data

            val locationText = binding.searchView.query.toString() // take the text inside the SearchView

            if (locationText.isNotEmpty()) {
                // create a bundle and add the data
                val bundle = Bundle()
                bundle.putString("locationKey", locationText)

                // direct to AddPostFragment and send the data
                val addPostFragment = AddPostFragment()
                addPostFragment.arguments = bundle

                requireActivity().supportFragmentManager.beginTransaction()
                    .replace(R.id.frame_layout, addPostFragment)
                    .addToBackStack(null)
                    .commit()
            } else {
                Toast.makeText(requireContext(), "Please select a location ", Toast.LENGTH_SHORT).show()
            }
        }

        binding.btnMyLocation.setOnClickListener {
            if(ContextCompat.checkSelfPermission(requireContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED){
                //request permission
                if(ActivityCompat.shouldShowRequestPermissionRationale(requireActivity(),Manifest.permission.ACCESS_FINE_LOCATION)){
                    Snackbar.make(binding.root, "Permission needed for location.", Snackbar.LENGTH_INDEFINITE).setAction("Grant"){
                        permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                    }.show()
                }else{
                    permissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
                }
            }else{
                //permission granted
                fetchUserLocation()
            }
        }

    }

    private fun fetchUserLocation() {
        if (ActivityCompat.checkSelfPermission(requireContext(),Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            // Get last known location
            val lastLocation = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)

            if (lastLocation != null) {
                val userLatLng = LatLng(lastLocation.latitude, lastLocation.longitude)

                // Move camera to user's location
                googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(userLatLng, 15f))

                // Get address from coordinates
                val geocoder = Geocoder(requireContext(), Locale.getDefault())
                val addressList = geocoder.getFromLocation(lastLocation.latitude, lastLocation.longitude, 1)

                if (!addressList.isNullOrEmpty()) {
                    val address = addressList[0]

                    val formattedAddress = listOf(
                        address.subLocality,
                        address.thoroughfare,
                        address.locality,
                        address.adminArea
                    ).filterNotNull().filter { it.isNotEmpty() }.joinToString(", ")

                    // Update SearchView
                    binding.searchView.setQuery(formattedAddress, false)
                }

                // Add marker for user's location
                googleMap.clear()
                googleMap.addMarker(MarkerOptions().position(userLatLng).title("My Location"))
            } else {
                Toast.makeText(requireContext(), "Unable to get location!", Toast.LENGTH_SHORT).show()
            }
        }
    }


    private fun registerLauncher() {
        permissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()) { result ->
            if (result) {
                fetchUserLocation()
            } else {
                Toast.makeText(requireContext(), "Permission denied!", Toast.LENGTH_LONG).show()
            }
        }
    }


    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }


}
