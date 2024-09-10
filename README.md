# Rostr Merchant App

This repository hosts the **Rostr Merchant App**, a mobile application for gig workers to list their services on the decentralized [Rostr](https://github.com/devcdis/rostr) network, powered by the Nostr protocol.

## Features

- **Service Listing**: Gig workers can advertise their services on nearby relays.
- **Relay Selection**: View and select relays based on factors like location, cost, and reach.
- **Relay Management**: Add, update, or remove your service listings from multiple relays in real-time.
- **Decentralized and Transparent**: No central authority controls the marketplace, giving workers full control over where and how they list their services.

## How It Works

The Rostr Merchant App allows gig workers to connect with **relay servers**, where they can list their services for potential customers to discover.

1. **Fetch Relay List**: Upon setup, the app fetches a list of available relays from a master server, allowing workers to view relay information such as cost and reach.
2. **Service Listing**: Workers can select one or more relays to advertise their services. They submit details such as the service offered, pricing, and contact information to the selected relays.
3. **Manage Listings**: Merchants can update, modify, or remove their services from the relays as needed. The app ensures that workers have complete control over where their services are advertised.


## Relay Management

The app provides gig workers with detailed information about available relays, including:

- **Relay Location**: Find relays in your geographic area.
- **Cost of Advertising**: See the price of advertising on each relay.
- **Relay Reach**: View the number of daily customers each relay serves, along with other metrics such as operating radius.

Once a worker selects a relay, their service listings (including service type, pricing, and contact details) are sent to the relay via WebSocket. The listings are then made available for potential customers to discover.

Rostr is a decentralized FOSS gig marketplace built on the Nostr protocol. Learn more at [Rostr](https://github.com/devcdis/rostr).
