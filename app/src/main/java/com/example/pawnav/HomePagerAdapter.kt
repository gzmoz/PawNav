package com.example.pawnav

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter

// HomePagerAdapter, ViewPager2 ile Fragment'leri yönetmek için kullanılır.
class HomePagerAdapter(fragmentActivity: FragmentActivity) : FragmentStateAdapter(fragmentActivity) {

    // Fragment listesini tanımlıyoruz. (PostFragment ve MapFragment)
    private val fragmentList = listOf(PostFragment(), MapsFragment())

    // Kaç tane fragment olduğunu döndüren fonksiyon.
    override fun getItemCount(): Int = fragmentList.size

    // Belirli bir pozisyondaki fragmenti oluşturan fonksiyon.
    override fun createFragment(position: Int): Fragment = fragmentList[position]
}