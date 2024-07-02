// SPDX-FileCopyrightText: 2024 EasyDiffraction contributors <app@easyscience.software>
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

import Gui.Globals as Globals

// Mock for the backend functionality
QtObject { // If "Unknown component. (M300) in QtCreator", try: "Tools > QML/JS > Reset Code Model"

    ///////////////
    // About dialog
    ///////////////

    readonly property var about: {
        'name': 'EasyExample',
        'namePrefix': 'Easy',
        'nameSuffix': 'Example',
        'namePrefixForLogo': 'easy',
        'nameSuffixForLogo': 'example',
        'homePageUrl': 'https://github.com/EasyScience/EasyExample',
        'issuesUrl': 'https://github.com/EasyScience/EasyExample/issues',
        'licenseUrl': 'https://github.com/EasyScience/EasyExample/LICENCE.md',
        'dependenciesUrl': 'https://github.com/EasyScience/EasyExample/DEPENDENCIES.md',
        'version': '1.0.1',
        'icon': Qt.resolvedUrl('../Resources/Logos/App.svg'),
        'date': new Date().toISOString().slice(0,10),
        'developerYearsFrom': "2019",
        'developerYearsTo': "2024",
        'description': 'EasyExample is an example of how to build the basic application using EasyApp module.\n\nEasyExample is developed by the European Spallation Source ERIC, Sweden.',
        'developerIcons': [
            {
                'url': "https://ess.eu",
                'icon': Qt.resolvedUrl('../Resources/Logos/ESS.png'),
                'heightScale': 3.0
            }
        ]
    }

    /////////////
    // Status bar
    /////////////

    readonly property var status: {
        'project': 'Undefined',
        'phaseCount': '1',
        'experimentsCount': '1',
        'calculator': 'CrysPy',
        'minimizer': 'Lmfit (leastsq)',
        'variables': '31 (3 free, 28 fixed)'
    }

    ///////////////
    // Project page
    ///////////////

    readonly property var project: QtObject {
        property bool created: false

        readonly property var info: {
            'name': 'Super duper project',
            'description': 'Default project description from Mock proxy',
            'location': '/path to the project',
            'creationDate': ''
        }

        readonly property var examples: [
            {
                "description":"neutrons, powder, constant wavelength, HRPT@PSI",
                "name":"La0.5Ba0.5CoO3 (HRPT)",
                "path":":/Examples/La0.5Ba0.5CoO3_HRPT@PSI/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, HRPT@PSI",
                "name":"La0.5Ba0.5CoO3-Raw (HRPT)",
                "path":":/Examples/La0.5Ba0.5CoO3-Raw_HRPT@PSI/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, HRPT@PSI, 2 phases",
                "name":"La0.5Ba0.5CoO3-Mult-Phases (HRPT)",
                "path":":/Examples/La0.5Ba0.5CoO3-Mult-Phases_HRPT@PSI/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, D20@ILL",
                "name":"Co2SiO4 (D20)",
                "path":":/Examples/Co2SiO4_D20@ILL/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, G41@LLB",
                "name":"Dy3Al5O12 (G41)",
                "path":":/Examples/Dy3Al5O12_G41@LLB/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, D1A@ILL",
                "name":"PbSO4 (D1A)",
                "path":":/Examples/PbSO4_D1A@ILL/project.cif"
            },
            {
                "description":"neutrons, powder, constant wavelength, 3T2@LLB",
                "name":"LaMnO3 (3T2)",
                "path":":/Examples/LaMnO3_3T2@LLB/project.cif"
            }
        ]

        function create() {
            console.debug(`Creating project '${info.name}'`)
            info.creationDate = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
            infoChanged()  // Emit signal, as it is not emited automatically
            created = true
        }

        function save() {
            console.debug(`Saving project '${info.name}'`)
        }
    }

    ///////////////
    // Summary page
    ///////////////

    readonly property var summary: QtObject {
        property bool created: true

        readonly property string asHtml: '
        <!DOCTYPE html>
        <html>
        <style>
            th, td {
                padding-right: 18px;
            }
            th {
                text-align: left;
            }
        </style>
        <body>
            <table>
            <tr></tr>
            <!-- Summary title -->
            <tr>
                <td><h1>Summary</h1></td>
            </tr>
            <tr></tr>
            <!-- Project -->
        <tr>
            <td><h3>Project information</h3></td>
        </tr>
        <tr></tr>
        <tr>
            <th>Title</th>
            <th>La0.5Ba0.5CoO3</th>
        </tr>
        <tr>
            <td>Description</td>
            <td>neutrons, powder, constant wavelength, HRPT@PSI</td>
        </tr>
        <tr>
            <td>No. of phases</td>
            <td>1</td>
        </tr>
        <tr>
            <td>No. of experiments</td>
            <td>1</td>
        </tr>
        <tr></tr>
            <!-- Phases -->
            <tr>
                <td><h3>Crystal data</h3></td>
            </tr>
            <tr></tr>
        <tr>
            <th>Phase datablock</th>
            <th>lbco</th>
        </tr>
        <tr>
            <td>Crystal system, space group</td>
            <td>cubic,&nbsp;&nbsp;<i>P m -3 m</i></td>
        </tr>
        <tr>
            <td>Cell lengths: <i>a</i>, <i>b</i>, <i>c</i> (&#8491;)</td>
            <td>3.8909,&nbsp;&nbsp;3.8909,&nbsp;&nbsp;3.8909</td>
        </tr>
        <tr>
            <td>Cell angles: <i>&#593;</i>, <i>&beta;</i>, <i>&#611;</i> (&deg;)</td>
            <td>90.0,&nbsp;&nbsp;90.0,&nbsp;&nbsp;90.0</td>
        </tr>
        <tr></tr>
            <!-- Experiments -->
            <tr>
                <td><h3>Data collection</h3></td>
            </tr>
            <tr></tr>
        <tr>
            <th>Experiment datablock</th>
            <th>hrpt</th>
        </tr>
        <tr>
            <td>Radiation probe</td>
            <td>neutron</td>
        </tr>
        <tr>
            <td>Radiation type</td>
            <td>constant wavelength</td>
        </tr>
        <tr>
            <td>Measured range: min, max, inc (&deg;)</td>
            <td>10.0,&nbsp;&nbsp;164.85,&nbsp;&nbsp;0.049999999999999996</td>
        </tr>
        <tr>
            <td>No. of data points</td>
            <td>3098</td>
        </tr>
        <tr></tr>
            <!-- Analysis -->
            <tr>
                <td><h3>Refinement</h3></td>
            </tr>
            <tr></tr>
            <tr>
                <td>Calculation engine</td>
                <td>CrysPy &mdash; https://www.cryspy.fr</td>
            </tr>
            <tr>
                <td>Minimization engine</td>
                <td>Lmfit (leastsq) &mdash; https://lmfit.github.io/lmfit-py</td>
            </tr>
            <tr>
                <td>Goodness-of-fit: reduced <i>&chi;</i><sup>2</sup></td>
                <td>1.25</td>
            </tr>
            <tr>
                <td>No. of parameters: total, free, fixed</td>
                <td>31,&nbsp;&nbsp;3,&nbsp;&nbsp;28</td>
            </tr>
            <tr>
                <td>No. of constraints</td>
                <td>0</td>
            </tr>
            <tr></tr>
            </table>
        </body>
        </html>
        '
    }

}
