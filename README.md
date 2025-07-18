# Install Jeffrey Test App using Helm

#### Manually adding PV/PVC
```
kubectl apply -f ./jeffrey-console/templates/persistent-volume.yaml

kubectl delete -f ./jeffrey-console/templates/persistent-volume-claim.yaml && \
kubectl delete -f ./jeffrey-console/templates/persistent-volume.yaml
```

#### Start Minikube and deploy Applications using Helm

```bash
helm upgrade --install jeffrey-console ./jeffrey-console && \
helm upgrade --install jeffrey-testapp-client ./jeffrey-testapp-client  && \
helm upgrade --install jeffrey-testapp-direct-server ./jeffrey-testapp-server --set mode=direct && \
helm upgrade --install jeffrey-testapp-dom-server ./jeffrey-testapp-server --set mode=dom
```

```bash
helm uninstall jeffrey-console && \
helm uninstall jeffrey-testapp-client && \
helm uninstall jeffrey-testapp-dom-server && \
helm uninstall jeffrey-testapp-direct-server
```
