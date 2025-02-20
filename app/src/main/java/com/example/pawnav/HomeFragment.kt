package com.example.pawnav

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.viewpager2.widget.ViewPager2
import com.example.pawnav.databinding.ActivityMainBinding
import com.example.pawnav.databinding.FragmentHomeBinding
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator


class HomeFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_home, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Find TabLayout and ViewPager2 from the layout
        val tabLayout = view.findViewById<TabLayout>(R.id.tabLayout)
        val viewPager = view.findViewById<ViewPager2>(R.id.viewPager2)

        // Set the adapter for ViewPager2
        val adapter = HomePagerAdapter(requireActivity())
        viewPager.adapter = adapter

        // Bind TabLayout and ViewPager2 using TabLayoutMediator
        TabLayoutMediator(tabLayout, viewPager) { tab, position ->
            // tab -> Represents each tab in TabLayout
            // position -> Represents the current page in ViewPager2
            when (position) {
                0 -> {
                    tab.text = "Post"
                    tab.setIcon(R.drawable.posticon) // İkon ekleme
                }
                1 -> {
                    tab.text = "Map"
                    tab.setIcon(R.drawable.mapicon) // İkon ekleme
                }
            }
        }.attach()
    }
}