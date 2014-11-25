module Verisimilitude
  class VeritasWrapper

    def distribution(etcd_cluster_endpoints)
      `veritas distribution -etcdCluster="#{etcd_cluster_endpoints.join(',')}"`
    end

  end
end
