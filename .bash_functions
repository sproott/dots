connect() {
    bluetoothctl power on
    bluetoothctl connect $1
}

ds4() {
    connect DC:AF:68:08:78:03
}

jbl() {
    connect D8:37:3B:24:E7:42
}

marshall() {
    connect 2C:4D:79:C4:9C:F4
}