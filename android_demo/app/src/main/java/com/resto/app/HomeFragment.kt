package com.resto.app

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.resto.app.databinding.FragmentHomeBinding
import io.flutter.embedding.android.FlutterActivity

class HomeFragment : Fragment() {

    private var _binding: FragmentHomeBinding? = null
    private val binding get() = _binding!!

    private val menuItems = listOf(
        MenuItem("Flutter 页面", "点击进入 Flutter Module 页面")
    )

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.textHome.text = "欢迎来到首页"
        
        // 设置 RecyclerView
        binding.recyclerView.layoutManager = LinearLayoutManager(requireContext())
        binding.recyclerView.adapter = HomeListAdapter(menuItems) { item ->
            when (item.title) {
                "Flutter 页面" -> {
                    // 启动 Flutter 页面
                    startActivity(
                        FlutterActivity
                            .withNewEngine()
                            .initialRoute("/")
                            .build(requireContext())
                    )
                }
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    data class MenuItem(
        val title: String,
        val description: String
    )

    class HomeListAdapter(
        private val items: List<MenuItem>,
        private val onItemClick: (MenuItem) -> Unit
    ) : RecyclerView.Adapter<HomeListAdapter.ViewHolder>() {

        class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            val title: TextView = view.findViewById(R.id.item_title)
            val arrow: TextView = view.findViewById(R.id.item_arrow)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_home_list, parent, false)
            return ViewHolder(view)
        }

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            val item = items[position]
            holder.title.text = item.title
            holder.itemView.setOnClickListener {
                onItemClick(item)
            }
        }

        override fun getItemCount() = items.size
    }
}

