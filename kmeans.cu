#include "kmeans.h"
#include "util.h"

namespace kmeans {

void kmeans(int iterations,
            int n, int d, int k,
            thrust::device_vector<double>& data,
            thrust::device_vector<int>& labels,
            thrust::device_vector<double>& centroids,
            bool init_from_labels) {
    thrust::device_vector<double> data_dots(n);
    thrust::device_vector<double> centroid_dots(n);
    thrust::device_vector<double> pairwise_distances(n * k);
    
    detail::labels_init();
    detail::make_self_dots(n, d, data, data_dots);

    if (init_from_labels) {
        detail::find_centroids(n, d, k, data, labels, centroids);
    } 

    for(int i = 0; i < iterations; i++) {
        detail::calculate_distances(n, d, k,
                                    data, centroids, data_dots,
                                    centroid_dots, pairwise_distances);

        int changes = detail::relabel(n, k, pairwise_distances, labels);
       
        std::cout << "Iteration " << i << " produced " << changes
                  << " changes" << std::endl;
        
        detail::find_centroids(n, d, k, data, labels, centroids);
        
    }

}

}
