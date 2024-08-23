// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Logic.Mock as MockLogic


// If the backend_proxy_py object is created in main.py and exposed to qml, it is used as to access
// the necessary backend properties and methods. Otherwise, the mock proxy defined in
// MockLogic/BackendProxy.qml with hardcoded data is used.
// The assumption here is that the real backend proxy and the mock proxy have the same API.

QtObject {

    readonly property var proxy: {
        if (typeof backend_proxy_py !== 'undefined' && backend_proxy_py !== null) {
            console.debug('Currently, the real python backend proxy is in use')
            return backend_proxy_py
        } else {
            console.debug('Currently, the mock backend proxy is in use')
            return MockLogic.BackendProxy
        }
    }

}
