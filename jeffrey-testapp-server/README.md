# Jeffrey Testapp Server Helm Chart

This is a unified Helm chart for Jeffrey testapp server that supports both DOM and Direct modes.

## Usage

### Deploy DOM Mode
```bash
helm install dom-server . --set mode=dom
```

### Deploy Direct Mode
```bash
helm install direct-server . --set mode=direct
```

## Configuration

The main configuration parameter is `mode`:
- `mode: dom` - Sets `efficient.mode=false` in application.properties
- `mode: direct` - Sets `efficient.mode=true` in application.properties

This affects:
- InitContainer args: `/tmp/jeffrey/jeffrey-testapp-{mode}`
- Container command: `source /tmp/jeffrey/jeffrey-testapp-{mode}/.env`
- Application properties: `efficient.mode={true|false}`

## Migration from Separate Charts

This chart replaces:
- `jeffrey-testapp-dom-server` (use `mode: dom`)
- `jeffrey-testapp-direct-server` (use `mode: direct`)

All other configuration remains the same.
