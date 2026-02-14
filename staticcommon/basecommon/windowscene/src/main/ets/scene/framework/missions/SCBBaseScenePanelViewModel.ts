/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneMissionManager, SCBScreenProperty,
} from '../../../TsIndex';
import { SceneMissionMgmtStage } from '../../manager/SCBSceneMissionManager';
import { SCBScenePanelMissionHandler } from './SCBScenePanelMissionHandler';

const TAG = '[SCBMission]SCBBaseScenePanelViewModel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export const PANEL_ID_CONCAT_CONSTANT = 100;

/**
 * BaseScenePanelViewModel for product panel.
 */
export class SCBBaseScenePanelViewModel<T extends SCBScenePanelMissionHandler> {
  screenId: number;
  panelId: number;
  panelName: string;
  screenProperty: SCBScreenProperty;
  // more handlers can be expanded, mission management handler is necessary for the framework.
  missionHandler: T;

  /**
   * constructor of panel view model.
   * @param handler new instance of mission handler
   * @param screenProperty screen property
   */
  public constructor(handler: T, screenProperty: SCBScreenProperty) {
    this.missionHandler = handler;
    this.screenProperty = screenProperty;
    this.screenId = screenProperty.screenId;
    if (screenProperty.screenId !== this.missionHandler.screenId) {
      this.missionHandler.resetScreenProperty(screenProperty, 'bind same screen when init');
    }
    this.panelId = handler.panelId;
    this.panelName = `Screen${this.screenId}_ScenePanel${this.panelId}`;
    SCBSceneMissionManager.getInstance().init(SceneMissionMgmtStage.ON_SCENE_PANEL_HANDLER_CREATE,
      null, this.missionHandler);
  }

  /**
   * log tag
   * @returns tag string
   */
  public get logTag(): string {
    return `[Screen:${this.screenId}][Panel:${this.panelId}]`;
  }

  /**
   * trigger on SCBScenePanel UI component aboutToAppear and after everything registered.
   */
  public laterInitOnPanelAppear(): void {
    log.showInfo(`${this.missionHandler.logTag} appear to init.`);
    SCBSceneMissionManager.getInstance().init(SceneMissionMgmtStage.ON_SCENE_PANEL_INIT, null, this.missionHandler);
  }

  /**
   * trigger on SCBScenePanel UI component aboutToDisappear and after everything unregistered.
   */
  public laterReleaseOnPanelDisappear(): void {
    log.showInfo(`${this.missionHandler.logTag} disappear to release.`);
    SCBSceneMissionManager.getInstance().release(SceneMissionMgmtStage.ON_SCENE_PANEL_RELEASE, this.missionHandler);
  }
}