# SPDX-FileCopyrightText: 2023 EasyExample contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2023 Contributors to the EasyExample project <https://github.com/EasyScience/EasyExampleApp>

from PySide6.QtCore import QObject


class Connections(QObject):

    def __init__(self, parent):
        super().__init__(parent)
        self._proxy = parent

        # Project
        self._proxy.project.dataChanged.connect(self.onProjectDataChanged)
        self._proxy.project.createdChanged.connect(self.onProjectDataChanged)

        # # Experiment
        # self._proxy.experiment.dataBlocksChanged.connect(self.onExperimentDataBlocksChanged)
        # self._proxy.experiment.yMeasArraysChanged.connect(self.onExperimentYMeasArraysChanged)
        # self._proxy.experiment.yBkgArraysChanged.connect(self.onExperimentYBkgArraysChanged)
        # self._proxy.experiment.parameterEdited.connect(self.onExperimentParameterEdited)
        # self._proxy.experiment.currentIndexChanged.connect(self.onExperimentCurrentIndexChanged)

        # # Model
        # self._proxy.model.dataBlocksChanged.connect(self.onModelDataBlocksChanged)
        # self._proxy.model.yCalcArraysChanged.connect(self.onModelYCalcArraysChanged)
        # self._proxy.model.parameterEdited.connect(self.onModelParameterEdited)
        # self._proxy.model.currentIndexChanged.connect(self.onModelCurrentIndexChanged)

        # # Analysis
        # self._proxy.analysis.definedChanged.connect(self.onAnalysisDefined)
        # self._proxy.analysis.yCalcTotalChanged.connect(self.onAnalysisYCalcTotalChanged)

        # # Fittables
        # self._proxy.fittables.dataChanged.connect(self.onFittablesDataChanged)

        # # Fitting
        # #self._proxy.fitting.isFittingNowChanged.connect(self.onIsFittingNowChanged)

    # Project
    def onProjectDataChanged(self):
        self._proxy.project.setNeedSaveToTrue()

    # def onProjectCreatedChanged(self):
    #     self._proxy.project.save()

    # # Experiment

    # def onExperimentDataBlocksChanged(self):
    #     self._proxy.experiment.defined = bool(len(self._proxy.experiment.dataBlocks))
    #     self._proxy.experiment.setDataBlocksJson()
    #     self._proxy.project.setNeedSaveToTrue()

    # def onExperimentYMeasArraysChanged(self):
    #     self._proxy.status.refresh()
    #     self._proxy.plotting.drawMeasuredOnExperimentChart()

    # def onExperimentYBkgArraysChanged(self):
    #     self._proxy.analysis.calculateYCalcTotal()
    #     self._proxy.plotting.drawBackgroundOnExperimentChart()
    #     self._proxy.plotting.redrawBackgroundOnAnalysisChart()

    # def onExperimentParameterEdited(self, page, name):
    #     self._proxy.experiment.setDataBlocksJson()
    #     if name.startswith('background'):
    #         self._proxy.experiment.updateCurrentExperimentYBkgArray()
    #     if page != 'analysis':
    #         self._proxy.fittables.set()
    #     self._proxy.project.setNeedSaveToTrue()

    # def onExperimentCurrentIndexChanged(self):
    #     self._proxy.plotting.drawMeasuredOnExperimentChart()
    #     self._proxy.plotting.drawBackgroundOnExperimentChart()

    # # Model

    # def onModelDataBlocksChanged(self):
    #     self._proxy.model.defined = bool(len(self._proxy.model.dataBlocks))
    #     self._proxy.model.setDataBlocksJson()
    #     self._proxy.project.setNeedSaveToTrue()

    # def onModelYCalcArraysChanged(self):
    #     self._proxy.analysis.calculateYCalcTotal()
    #     self._proxy.plotting.drawCalculatedOnModelChart()

    # def onModelParameterEdited(self, page, blockIndex, name):
    #     self._proxy.model.setDataBlocksJson()
    #     if page != 'analysis':
    #         self._proxy.fittables.set()
    #         self._proxy.model.updateCurrentModelYCalcArray()
    #     else:
    #         self._proxy.model.updateYCalcArrayByIndex(blockIndex)
    #     self._proxy.project.setNeedSaveToTrue()

    # def onModelCurrentIndexChanged(self):
    #     self._proxy.plotting.drawCalculatedOnModelChart()

    # # Analysis

    # def onAnalysisDefined(self):
    #     self._proxy.fittables.set()
    #     self._proxy.plotting.drawAllOnAnalysisChart()

    # def onAnalysisYCalcTotalChanged(self):
    #     self._proxy.plotting.redrawCalculatedOnAnalysisChart()
    #     self._proxy.plotting.redrawResidualOnAnalysisChart()

    # # Fittables

    # def onFittablesDataChanged(self):
    #     self._proxy.fittables.setDataJson()

    # # Fitting

    # def onIsFittingNowChanged(self):
    #     pass
    #     #print(f'Fit finished: {self._proxy.fitting.fitFinished}')
    #     #needSetFittables = True
    #     #self._proxy.model.parametersEdited.emit(needSetFittables)
