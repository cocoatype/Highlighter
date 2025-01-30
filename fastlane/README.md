fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Submit a new beta build to Apple TestFlight

### ios public

```sh
[bundle exec] fastlane ios public
```

Submit a new beta build to the public TestFlight beta

### ios dev

```sh
[bundle exec] fastlane ios dev
```

Set up developer environment

### ios renew

```sh
[bundle exec] fastlane ios renew
```

Renew signing certs

----


## Mac

### mac test

```sh
[bundle exec] fastlane mac test
```

Runs all the tests

### mac beta

```sh
[bundle exec] fastlane mac beta
```

Submit a new beta build to Apple TestFlight

### mac public

```sh
[bundle exec] fastlane mac public
```

Submit a new beta build to the public TestFlight beta

### mac dev

```sh
[bundle exec] fastlane mac dev
```

Set up developer environment

### mac renew

```sh
[bundle exec] fastlane mac renew
```

Renew signing certs

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
