// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

QtObject {

    property bool created: false

    property string name: ''

    readonly property var info: {
        'description': '',
        'location': '',
        'creationDate': ''
    }

    readonly property var examples: [
        {
            'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
            'name': 'La0.5Ba0.5CoO3 (HRPT)',
            'path': ':/Examples/La0.5Ba0.5CoO3_HRPT@PSI/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
            'name': 'La0.5Ba0.5CoO3-Raw (HRPT)',
            'path': ':/Examples/La0.5Ba0.5CoO3-Raw_HRPT@PSI/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, HRPT@PSI, 2 phases',
            'name': 'La0.5Ba0.5CoO3-Mult-Phases (HRPT)',
            'path': ':/Examples/La0.5Ba0.5CoO3-Mult-Phases_HRPT@PSI/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, D20@ILL',
            'name': 'Co2SiO4 (D20)',
            'path': ':/Examples/Co2SiO4_D20@ILL/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, G41@LLB',
            'name': 'Dy3Al5O12 (G41)',
            'path': ':/Examples/Dy3Al5O12_G41@LLB/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, D1A@ILL',
            'name': 'PbSO4 (D1A)',
            'path': ':/Examples/PbSO4_D1A@ILL/project.cif'
        },
        {
            'description': 'neutrons, powder, constant wavelength, 3T2@LLB',
            'name': 'LaMnO3 (3T2)',
            'path': ':/Examples/LaMnO3_3T2@LLB/project.cif'
        }
    ]

    function create() {
        console.debug(`Creating project '${name}'`)
        info.creationDate = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
        infoChanged()  // this signal is not emitted automatically when only part of the object is changed
        created = true
    }

    function save() {
        console.debug(`NOT IMPLEMENTED: Saving project '${name}'`)
    }

    function edit_info(path, new_value) {
        console.debug(`NOT IMPLEMENTED: Changing project info.${path} from '${info.path}' to '${new_value}'`)
    }

}
