# kristian-app

Kristian App is everything you need to run an application smudly in k8s. 

## Prerequisites

- Helm >3

## Dependencies

## Testing
Install Unit test plugin:
```
helm plugin install https://github.com/helm-unittest/helm-unittest.git --verify=false
```
Run unit tests
```
helm unittest -f 'tests/*.yaml' kristian-app
```